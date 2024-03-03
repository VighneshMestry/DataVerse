import 'package:permission_handler/permission_handler.dart';

class CheckPermission {
  isStoragePermission() async {
    
    await Permission.storage.request();
    var isStorage = await Permission.storage.status;
    if (!isStorage.isGranted) {
      await Permission.storage.request();
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