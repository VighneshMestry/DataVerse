import 'package:permission_handler/permission_handler.dart';

class CheckPermission {
  isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    if (!isStorage.isGranted) {
      isStorage = await Permission.manageExternalStorage.request();
      if (!isStorage.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}