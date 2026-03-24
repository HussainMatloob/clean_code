import 'dart:io';
import 'dart:isolate';
import 'package:get/get.dart';
import '../models/file_model.dart';
import '../services/file_scan_service.dart';

class ScanController extends GetxController {
  RxBool isScanning = false.obs;
  RxInt progress = 0.obs;
  RxList<FileModel> files = <FileModel>[].obs;

  Isolate? isolate;

  void startScan() async {
    isScanning.value = true;
    progress.value = 0;
    files.clear();

    ReceivePort receivePort = ReceivePort();

    isolate = await Isolate.spawn(scanFilesIsolate, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is Map) {
        if (message.containsKey('progress')) {
          progress.value = message['progress'];
        }

        if (message.containsKey('done')) {
          List data = message['done'];

          files.value = data.map((e) {
            return FileModel(
              path: e['path'],
              sizeMB: e['size'],
              isHidden: e['hidden'],
            );
          }).toList();

          isScanning.value = false;
          isolate?.kill();
        }
      }
    });
  }

  void deleteFile(FileModel file) async {
    try {
      File(file.path).deleteSync(recursive: true);
      files.remove(file);
    } catch (e) {
      print("Delete failed");
    }
  }
}
