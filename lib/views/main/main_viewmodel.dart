import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/services/authentication.dart';
class MainViewModel extends BaseViewModel{

 int currentIndex = 0;
 changeIndex(int index){
   currentIndex =  index;
   notifyListeners();

 }
 

  AuthService _authService = locator<AuthService>() ;
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();


  Future doSignOut() async{
   await _authService.signOut();

  }
  handleAuth() async {
    final user = await _authService.getUser();
    if(user!=null){
    final res = await  _dialogService.showConfirmationDialog(
      title: 'Sign out?',
        description: 'Are you sure you want to sign out?'

      );

      if(res.confirmed){
         _authService.signOut();

      }

    }else{

       _navigationService.navigateTo(RoutesNames.logInView);

    }
    notifyListeners();
    
  }




 
}