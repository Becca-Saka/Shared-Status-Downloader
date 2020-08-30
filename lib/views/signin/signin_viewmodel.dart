import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/authentication.dart';

class SignInViewModel extends BaseViewModel{
  SnackbarService _snackbarService = locator<SnackbarService>();
  AuthService _authService = locator<AuthService>() ;
  NavigationService _navigationService = locator<NavigationService>();

 


  Future doSignIn(String email, String password) async{
    if(email.isEmpty){
       _snackbarService.showSnackbar(
        message: 'Email cannot be empty',
        duration: Duration(milliseconds: 1200),

        );
    }else{

      if(password.isEmpty){
       _snackbarService.showSnackbar(
        message: 'Invalid Password',
        duration: Duration(milliseconds: 1200),

        );
    }else{
       final result = await _authService.signInUser(email, password);
    if(result is bool){
      _navigationService.popUntil((route) => route.isFirst);

    }else {
      print('error');
      _snackbarService.showSnackbar(
        message: 'Something went wrong! Please try again',
        title: 'Test',
        duration: Duration(milliseconds: 1200),

        );
     
      print(result);
    }}}
  

  //  return result;
   

  }


}