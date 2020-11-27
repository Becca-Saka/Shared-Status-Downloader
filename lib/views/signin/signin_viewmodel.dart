import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/authentication.dart';
import 'package:status_downloader/services/dialogs_service.dart';

class SignInViewModel extends BaseViewModel{
  SnackbarService _snackbarService = locator<SnackbarService>();
  AuthService _authService = locator<AuthService>() ;
  NavigationService _navigationService = locator<NavigationService>();

 


  Future doSignIn(String email, String password,context, globalKey) async{
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
        MyDialogService().showLoadingDialog(context, globalKey);
       final result = await _authService.signInUser(email, password);
    if(result is bool){
      _navigationService.popUntil((route) => route.isFirst);

    }else {
      print('error');
     await  Future.delayed(Duration(milliseconds: 1000));
     _navigationService.popRepeated(1);
      _snackbarService.showSnackbar(
        message: 'Something went wrong! Please try again',
        title: 'Opss',
        duration: Duration(milliseconds: 1200),

        );
     
      print(result);
    }}}
  

  //  return result;
   

  }


}