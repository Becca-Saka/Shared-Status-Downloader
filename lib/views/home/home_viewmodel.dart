
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_downloader/services/permission_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class HomeViewModel extends BaseViewModel{
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;
  PermissionService _permissionServices;
  bool isPermitted = false;
  bool get isLoadBusy => _isLoadBusy;
  bool _isLoadBusy = true;
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
  new Directory('/storage/emulated/0/Whatsapp/Media/.Statuses');
  VideoPlayerController controller;
  Future<void> intializeVideoPlayerFuture;

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


  storagePermissionChecker () async{
    _isLoadBusy = true;
    notifyListeners();
    isPermitted = await getStoragePermission();
    _isLoadBusy = false;
    notifyListeners();
    // print(isPermitted);
  //  if(isPermitted){
    
  //    // permitted

  //  }else{
  //   isPermitted = await requestStoragePermission();
  //  }
   
  }

  getAllStatus(){
    if(_isLoadBusy == false){
    _isLoadBusy = true;
      notifyListeners();
      }
    if(!isPermitted){
      if(!Directory('${_photoDirectory.path}').existsSync()){
        isWhatsappInstalled = false;
      
    }else{
      print('exist');
      final _list= _photoDirectory.listSync().map((e) => e.path);
      _statusImageList = _list.where((element) => element.endsWith('.jpg'))
      .toList(growable: false);
       _statusVideoList = _list.where((element) => element.endsWith('.mp4'))
      .toList(growable: false);
       }

    }else{
      print('na me');
    }
  _isLoadBusy = false;
  notifyListeners();
  
  }
  getThumbNails() async{
    for(final item in _statusVideoList){
      var thumb = await VideoThumbnail
      .thumbnailData(video: item,
        quality: 50,
        imageFormat: ImageFormat.JPEG);
        _statusVideoes.add(new VideoModel(item,thumb));

    }

  notifyListeners();
  
  }
  
  saveImage(path) async{
    Uri uri = Uri.parse(path);
    File file = new File.fromUri(uri);
    Uint8List bytes;
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError){
      print(onError.toString());
    });
    final result =  await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    print(result);

    
  }
  initializeVideoController(path){
    File file = File(path);
    print(file.path);
    controller = VideoPlayerController.file(file);
    intializeVideoPlayerFuture = controller.initialize();
    notifyListeners();
    print(controller.value);
  }

  playPause(){
    if(controller.value.isPlaying){
      controller.pause();
    }else{
      controller.play();
    }
    notifyListeners();
  }

  saveVideo(videoPath) async{

    Uri uri = Uri.parse(videoPath);
    File file = new File.fromUri(uri);
    String path = '/storage/emulated/0/status_downloader';
    if(!Directory(path).existsSync()){
      Directory(path).createSync(recursive:true);

    }
    final date = DateTime.now().millisecondsSinceEpoch;
    String newName ='$path/VID-$date.mp4';
    final gg = await file.copy(newName);
    print(gg);
    // file.copy(newPath);
    

    
  }

  share(path, bool isImage) async{
    // Share.share(path);
    
    final ByteData byte = await rootBundle.load(path);
    await WcFlutterShare.share(sharePopupTitle: 'Share', 
    mimeType: isImage?'image/jpg':'video/mp4',
    fileName: path,
    text: 'This is the text',
    bytesOfFile: byte.buffer.asUint8List()
    );
  }

  
}

class VideoModel{
  String path;
  Uint8List thumb;
  VideoModel(this.path, this.thumb);
}