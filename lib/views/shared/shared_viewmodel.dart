import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/authentication.dart';

class SharedViewModel extends BaseViewModel{
  String value = 'Images';
  List<String> dropDown= [
    'Images',
    'Videos'
  ];
  List<String> get imageList => _imageList;
  List<String> _imageList = [];
  List<String> get videoList => _videoList;
  List<String> _videoList = [];
  
  AuthService _authService = AuthService() ;
  bool get isSignedIn => _authService.isSignIn(); 


  changeValue(newValue){
    value = newValue;
    notifyListeners();

  }

}