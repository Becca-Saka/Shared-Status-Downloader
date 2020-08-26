
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/authentication.dart';
class MainViewModel extends BaseViewModel{
 int currentIndex = 0;
 changeIndex(int index){
   currentIndex =  index;
   notifyListeners();

 }
 
}