import 'package:permission_handler/permission_handler.dart';

class PermissionService{
  // Future<bool> requestStoragePermission() async{
  //   Map<Permission, PermissionStatus> result = await [Permission.storage].request();
  //   if(result[Permission.storage].isDenied){
  //     isPermitted = false;
  //     notifyListeners();
  //     return result[Permission.storage].isDenied;

  //   }else if(result[Permission.storage].isGranted){
  //     isPermitted = true;
  //     notifyListeners();
  //     return result[Permission.storage].isGranted;
  //   }else{
  //     isPermitted = false;
  //     notifyListeners();
  //     return result[Permission.storage].isUndetermined;
  //   }

  // }
 

  Future<bool> getStoragePermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.storage].request();
      return permissionStatus[Permission.storage] == PermissionStatus.granted;
    } else {
      return permission == PermissionStatus.granted;
    }
  }

}