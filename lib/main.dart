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
  
  setUpLocator();
  DynamicLinkService _dynamicLinkService= locator<DynamicLinkService>();
  _dynamicLinkService.retriveDynamicLinks();

 
  
  runApp( MyApp(),);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Status Downloader',
      theme: ThemeData(
        
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // darkTheme: ThemeData.dark(),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Routes().onGenerateRoute,
      initialRoute: RoutesNames.mainView,
      debugShowCheckedModeBanner: false,
    );
  }
}

