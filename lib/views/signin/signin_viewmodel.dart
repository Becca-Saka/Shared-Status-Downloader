import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/authentication.dart';

class SignInViewModel extends BaseViewModel{
  AuthService _authService = AuthService() ;


  Future doSignIn(email, password) async{
   await _authService.signInUser(email, password);

  }


}