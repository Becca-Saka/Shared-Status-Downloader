import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/home/home_view.dart';
import 'package:status_downloader/views/shared/shared_view.dart';
import 'main_viewmodel.dart';

class MainView extends StatelessWidget {

   final List<Widget> _screens = [
    HomeView(),
    SharedView()

  ];
  var _currentScreen = 0;


  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context,model, child){
        return Scaffold(
          body: _screens[model.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: model.changeIndex,
            currentIndex: model.currentIndex,
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.phone),
            title: Text('Local')),
          
            BottomNavigationBarItem(icon: Icon(Icons.folder_shared),
            title: Text('Shared')),
          ])
        );
      },
      viewModelBuilder: ()=> MainViewModel() ,

    );
  }
}
