import 'package:stacked/stacked.dart';

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

  changeValue(newValue){
    value = newValue;
    notifyListeners();

  }

}