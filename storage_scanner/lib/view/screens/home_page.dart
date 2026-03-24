import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_scanner/controller/scan_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(ScanController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Storage Scanner")),
      body: Column(
        children: [
          ElevatedButton(onPressed: () async {}, child: Text("Start Scan")),

          Obx(() {
            if (controller.isScanning.value) {
              return Column(
                children: [
                  CircularProgressIndicator(),
                  Text("Scanned: ${controller.progress.value} files"),
                ],
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: controller.files.length,
                itemBuilder: (context, index) {
                  var file = controller.files[index];

                  return ListTile(
                    title: Text(file.path),
                    subtitle: Text(
                      "${file.sizeMB.toStringAsFixed(2)} MB | Hidden: ${file.isHidden}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        controller.deleteFile(file);
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}


//onTap
  // await requestPermission();
  //             controller.startScan();