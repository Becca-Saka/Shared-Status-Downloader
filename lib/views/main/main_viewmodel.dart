
import 'package:stacked/stacked.dart';
class MainViewModel extends BaseViewModel{
 int currentIndex = 0;
 changeIndex(int index){
   currentIndex =  index;
   notifyListeners();

 }
}