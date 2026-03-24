import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  var status = await Permission.manageExternalStorage.request();
  return status.isGranted;
}
