// import 'package:fipple/ui/views/initial_start_up/signin/signin_view.dart';
// import 'package:fipple/ui/views/initial_start_up/signup/signup_view.dart';
// import 'package:fipple/ui/views/initial_start_up/startup/startup_view.dart';
// import 'package:fipple/ui/views/main/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_downloader/views/downloaded/previewers/download_image_preview.dart';
import 'package:status_downloader/views/downloaded/previewers/download_video_preview.dart';
import 'package:status_downloader/views/home/previewers/image_preview.dart';
import 'package:status_downloader/views/home/previewers/video_preview.dart';
import 'package:status_downloader/views/main/main_view.dart';
import 'package:status_downloader/views/shared/database_previewers/database_image_preview.dart';
import 'package:status_downloader/views/shared/database_previewers/database_video_preview.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'package:status_downloader/views/signup/signup_view.dart';

abstract class RoutesNames {
  static const startupView = '/';
  static const onboardingViewRoute = '/onboarding';
  static const mainView = '/mainView';
  static const logInView = '/logInView';
  static const signUpView = '/signUpView';
  static const imagesPreview = '/imagesPreview';
  static const videoPreview = '/videoPreview';
  static const databaseImagePreview = '/databaseImagePreview';
  static const databaseVideoPreview = '/databaseVideoPreview';
  static const downloadedImagesView = '/downloadedImagesView';
  static const downloadedVideosView = '/downloadedVideosView';
}

class Routes {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
        // case RoutesNames.startupView:
        // return CupertinoPageRoute<dynamic>(
        //   builder: (context) => StartUpView(),
        //   settings: settings,
        // );

      case RoutesNames.mainView:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => MainView(),
          settings: settings,
        );

      case RoutesNames.signUpView:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => SignUpView(),
          settings: settings,
        );

      case RoutesNames.logInView:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => SignInView(),
          settings: settings,
        );
      case RoutesNames.imagesPreview:
      final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => ImagesPreview(argument),
          settings: settings,
        );

      case RoutesNames.videoPreview:
      final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => VideosPreview(argument),
          settings: settings,
        );

     case RoutesNames.databaseImagePreview:
      final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => DatabaseImagesPreview(argument),
          settings: settings,
        );

     case RoutesNames.databaseVideoPreview:
      final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => DatabaseVideosPreview(argument),
          settings: settings,
        );

      case RoutesNames.downloadedImagesView:
       final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => DownloadImagesPreview(argument),
          settings: settings,
        );
       case RoutesNames.downloadedVideosView:
        final argument = settings.arguments;
        return CupertinoPageRoute<dynamic>(
          builder: (context) => DownloadVideosPreview(argument),
          settings: settings,
        );







      default:
      return CupertinoPageRoute(
        builder: (_)=> Scaffold(
        body: Container(child: Center(child: Column(
          children: <Widget>[
            Text('No routes defined for ${settings.name}'),
             OutlineButton.icon(
                label: Text('Back'),
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(_).pop(),
              )
            
          ],
        )),),
      ),
    );
      
    }

  }
}
      