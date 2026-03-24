import 'dart:io';
import 'dart:isolate';

void scanFilesIsolate(SendPort sendPort) async {
  Directory root = Directory('/storage/emulated/0/');
  List<Map<String, dynamic>> result = [];

  int count = 0;

  Future<void> scanDir(Directory dir) async {
    try {
      //   Skip restricted folders BEFORE accessing
      if (dir.path.contains('/Android/data') ||
          dir.path.contains('/Android/obb')) {
        return;
      }

      await for (var entity in dir.list(followLinks: false)) {
        try {
          if (entity is Directory) {
            await scanDir(entity); // recursive call
          } else if (entity is File) {
            count++;

            int size = await entity.length();
            double sizeMB = size / (1024 * 1024);

            bool isHidden = entity.path.contains('/.');

            if (sizeMB > 50 || isHidden) {
              result.add({
                'path': entity.path,
                'size': sizeMB,
                'hidden': isHidden,
              });
            }

            // 🔹 progress update
            if (count % 100 == 0) {
              int percent = (count ~/ 1000);
              if (percent > 100) percent = 100;

              sendPort.send({'progress': percent});
            }
          }
        } catch (_) {}
      }
    } catch (_) {
      // ignore permission errors safely
    }
  }

  await scanDir(root);

  sendPort.send({'done': result});
}
