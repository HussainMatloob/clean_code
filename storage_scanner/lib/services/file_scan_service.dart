import 'dart:io';
import 'dart:isolate';

void scanFilesIsolate(SendPort sendPort) async {
  Directory root = Directory('/storage/emulated/0/');
  List<Map<String, dynamic>> result = [];

  int count = 0;

  await for (var entity in root.list(recursive: true, followLinks: false)) {
    try {
      count++;

      if (entity is File) {
        int size = await entity.length();
        double sizeMB = size / (1024 * 1024);

        bool isHidden = entity.path.contains('/.');

        if (sizeMB > 50 || isHidden) {
          result.add({'path': entity.path, 'size': sizeMB, 'hidden': isHidden});
        }
      }

      // Send progress every 100 files
      if (count % 100 == 0) {
        sendPort.send({'progress': count});
      }
    } catch (_) {}
  }

  sendPort.send({'done': result});
}
