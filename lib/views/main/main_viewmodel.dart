
import 'dart:io';
import 'dart:typed_data';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/services/authentication.dart';
import 'package:status_downloader/services/permision_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
class MainViewModel extends BaseViewModel{

  NavigationService _navigationService = locator<NavigationService>();
  // FireBaseService _firebaseService = locator<FireBaseService>();
  PermissionService _permissionService = locator<PermissionService>();
  // ConnectionService connectionService = locator<ConnectionService>();
  bool isPermitted = false;
  bool isWhatsappInstalled = true;
  List<VideoModel> _statusVideoes = [];
  List<VideoModel> get statusVideoes => _statusVideoes;
  List<String> _statusImageList = [];
  List<String> get statusImageList => _statusImageList;
  List<String> _statusVideoList = [];
  List<String> get statusVideoList => _statusVideoList;
  List<Uint8List> _statusVideoThumbList = [];
  List<Uint8List> get statusVideoThumbList => _statusVideoThumbList;
  final Directory _photoDirectory =
      new Directory('/storage/emulated/0/status_downloader');
 

  storagePermissionChecker() async {
    setBusy(true);
    notifyListeners();
    isPermitted = await _permissionService.getStoragePermission();
    setBusy(false);
    notifyListeners();
  }
  
 int currentIndex = 0;
 changeIndex(int index){
   currentIndex =  index;
   notifyListeners();

 }
 

  AuthService _authService = locator<AuthService>() ;


  Future doSignOut() async{
   await _authService.signOut();

  }

   getAllStatus() {
    setBusy(true);
    if (!isPermitted) {
      if (!Directory('${_photoDirectory.path}').existsSync()) {
        isWhatsappInstalled = false;
      } else {
        print('exist');
        final _list = _photoDirectory.listSync().map((e) => e.path);
        _statusImageList = _list
            .where((element) => element.endsWith('.jpg'))
            .toList(growable: false);
        _statusVideoList = _list
            .where((element) => element.endsWith('.mp4'))
            .toList(growable: false);
      }
    } else {
      print('na me');
    }
    setBusy(false);
    notifyListeners();
    
  }
   getThumbNails() async {
    setBusy(true);
    for (final item in _statusVideoList) {
      var thumb = await VideoThumbnail.thumbnailData(
          video: item, quality: 50, imageFormat: ImageFormat.JPEG);
      _statusVideoes.add(new VideoModel(item, thumb));
    }
    for(final item in _statusImageList){
      _statusVideoes.add(new VideoModel(item, null));
    }
    setBusy(false);

    notifyListeners();
  }

   navigateToImagePreview(imagePath) {
    _navigationService.navigateTo(RoutesNames.imagesPreview,
        arguments: imagePath);
  }

  navigateToVideoPreview(VideoModel videoModel) {
    _navigationService.navigateTo(RoutesNames.videoPreview,
        arguments: videoModel);
  }

   navigateToDownloadedView() {
    _navigationService.navigateTo(RoutesNames.downloadedView);
  }


 
}