import 'package:stacked/stacked.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/authentication.dart';
class MainViewModel extends BaseViewModel{

 int currentIndex = 0;
 changeIndex(int index){
   currentIndex =  index;
   notifyListeners();

 }
 

  AuthService _authService = locator<AuthService>() ;


  Future doSignOut() async{
   await _authService.signOut();

  }


 
}