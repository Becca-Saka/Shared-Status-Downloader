import 'package:admob_flutter/admob_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/views/main/main_view.dart';
import 'package:status_downloader/views/test_admob.dart';

import 'services/dynamic_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  Admob.initialize(testDeviceIds: ['C435CDA083D4EB3F581095B9ECB5728A']);
  setUpLocator();
  DynamicLinkService _dynamicLinkService= locator<DynamicLinkService>();
  _dynamicLinkService.retriveDynamicLinks();

 
  
  runApp(
    // DevicePreview(
    //   enabled :!kReleaseMode,
    //   builder: (context)=>
      MyApp(),
    // ),
    );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      title: 'Shared Status Saver',
      theme: ThemeData(
        
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // darkTheme: ThemeData.dark(),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Routes().onGenerateRoute,
      initialRoute: RoutesNames.mainView,
    );
  }
}

