import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/services/connection_service.dart';
import 'package:status_downloader/services/firebase_service.dart';
import 'package:status_downloader/services/permision_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:path/path.dart';

class DownloadViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FireBaseService _firebaseService = locator<FireBaseService>();
  PermissionService _permissionService = locator<PermissionService>();
  ConnectionService connectionService = locator<ConnectionService>();
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
      new Directory('/storage/emulated/0/Whatsapp/Media/.Statuses');
  VideoPlayerController controller;
  Future<void> intializeVideoPlayerFuture;

  storagePermissionChecker() async {
    setBusy(true);
    notifyListeners();
    isPermitted = await _permissionService.getStoragePermission();
    setBusy(false);
    notifyListeners();
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

  initializeVideoController(path) {
    File file = File(path);
    print(file.path);
    controller = VideoPlayerController.file(file);
    intializeVideoPlayerFuture = controller.initialize();
    notifyListeners();
    print(controller.value);
  }

  playPause() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    notifyListeners();
  }

  saveFile(videoPath, bool isImage) async {
    Uri uri = Uri.parse(videoPath);
    File file = new File.fromUri(uri);
    String path = '/storage/emulated/0/status_downloader';
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }
    final date = DateTime.now().millisecondsSinceEpoch;
    String newName = isImage ? '$path/IMG-$date.jpg' : '$path/VID-$date.mp4';
    final gg = await file.copy(newName);
    print(gg);
  }

  share(path, bool isImage) async {
    // Share.share(path);
    print(path);

    final ByteData byte = await rootBundle.load(path);
    String fileName = basename(path);
    await WcFlutterShare.share(
        sharePopupTitle: 'Share',
        mimeType: isImage ? 'image/jpg' : 'video/mp4',
        fileName: fileName,
        text: 'Save and share status',
        bytesOfFile: byte.buffer.asUint8List());
  }

  uploader(path) {
    print('yess');
  }

  Future<String> uploadFile(bool isImage,
      {VideoModel videoModel, String path}) async {
    File file = File(isImage ? path : videoModel.path);
    print('file');
    print(file.path);
    final uploaded = isImage
        ? await _firebaseService.uploadFile(
            file,
            isImage,
          )
        : await _firebaseService.uploadFile(file, isImage,
            thumb: videoModel.thumb);
    print('here');
    print(uploaded);
    return uploaded;
  }
}

class VideoModel {
  String path;
  Uint8List thumb;
  VideoModel(this.path, this.thumb);
}
