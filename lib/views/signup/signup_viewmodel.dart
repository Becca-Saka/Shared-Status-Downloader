import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/authentication.dart';

class SignUpViewModel extends BaseViewModel{
  AuthService _authService = AuthService() ;


  Future doSignUp(email, password) async{
   await _authService.signUp(email, password);

  }

}