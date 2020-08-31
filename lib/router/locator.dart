
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/services/authentication.dart';
import 'package:status_downloader/services/connection_service.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/services/dynamic_link_service.dart';
import 'package:status_downloader/services/firebase_service.dart';
import 'package:status_downloader/services/permision_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator(){
  
 
  locator.registerLazySingleton(() => PermissionService());
  locator.registerLazySingleton(() => ConnectionService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FireBaseService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => MyDialogService());
}
