import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/models/status_details.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/services/authentication.dart';
import 'package:status_downloader/services/dynamic_link_service.dart';
import 'package:status_downloader/services/firebase_service.dart';
import 'package:video_player/video_player.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:core';

class SharedViewModel extends BaseViewModel{
  NavigationService _navigationService = locator<NavigationService>();
  FireBaseService _fireBaseService = locator<FireBaseService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  String value = 'Shared By You';
  List<String> dropDown= [
    'Shared By You',
    'Shared With You'
  ];
  List<StatusDetails> get sharedByYou => _sharedByYou;
  List<StatusDetails> _sharedByYou = [];
  List<StatusDetails> get sharedWithYou => _sharedWithYou;
  List<StatusDetails> _sharedWithYou = [];
  
  
  AuthService _authService = AuthService() ;
  DynamicLinkService _dynamicLinkService = DynamicLinkService();
  bool get isSignedIn => _authService.isSignIn(); 
  final Directory _photoDirectory = 
  new Directory('/storage/emulated/0/Whatsapp/Media/.Statuses');
  VideoPlayerController controller;
  Future<void> intializeVideoPlayerFuture;



  changeValue(newValue){
    value = newValue;
    notifyListeners();

  }

  getData()async{
    setBusy(true);
    final docs = await _fireBaseService.getAllFromDataBase();
    if(docs.sharedByYou.length !=0){
     _sharedByYou = await  _fireBaseService.getSharedByYou(docs);
     _sharedWithYou = await  _fireBaseService.getSharedWithYou(docs);
     
    

    }
    setBusy(false);
    
   
    notifyListeners();
    //  print(_sharedByYou[1].runtimeType);
    
    

  }
   navigateToSignUp(){
    _navigationService.navigateTo(RoutesNames.logInView);

  }

   navigateToImagePreview(imagePath){
    _navigationService.navigateTo(RoutesNames.databaseImagePreview, arguments:imagePath);

  }
  navigateToVideoPreview(videoPath){
    _navigationService.navigateTo(RoutesNames.databaseVideoPreview, arguments:videoPath);

  }

   saveImage(path) async{
    //   String path = '/storage/emulated/0/status_downloader';
    // if(!Directory(path).existsSync()){
    //   Directory(path).createSync(recursive:true);

    // }
    // print(base64Decode(path));

    // var response = await Dio().
     


    // Uri uri = Uri.parse(path);
    // File file = new File.fromUri(uri);
    // Uint8List bytes;
    // await file.readAsBytes().then((value) {
    //   bytes = Uint8List.fromList(value);
    // }).catchError((onError){
    //   print(onError.toString());
    // });
    // // ImageGallerySaver.saveFile(file)
    // final result =  await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    // print(result);

    
  }
  initializeVideoController(path){
    File file = File(path);
    print(file.path);
    controller = VideoPlayerController.file(file);
    intializeVideoPlayerFuture = controller.initialize();
    notifyListeners();
    print(controller.value);
  }

   initializeNetworkVideoController(path){
    controller = VideoPlayerController.network(path);
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
  uploader(path){
    print('yess');
  }

  copyLink(link){
      Clipboard.setData(new ClipboardData(text: link))
      .whenComplete(() =>  _snackbarService.showSnackbar(message: 'Link copied',
      duration: Duration(milliseconds: 1000 )));
     
  }

  

}