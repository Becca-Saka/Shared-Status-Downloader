import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_view.dart';
import 'package:status_downloader/views/shared/shared_view.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'main_viewmodel.dart';

class MainView extends StatelessWidget {
    GlobalKey<State> _globalKey = new GlobalKey<State>();

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
           appBar: AppBar(
            title: Text('Shared Status Downloader'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.lightbulb_outline),
                onPressed: (){},
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                InkWell(
                  onTap: (){
                    MyDialogService().showLoadingDialog(context, _globalKey);
                    model.doSignOut()
                    .whenComplete(() => Navigator.pop(context))
                    .whenComplete(() => Navigator.pop(context))
                  .whenComplete(() =>  Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                    SignInView())));
                     

                    },
                child: Text('Sign Out'),
          ),
              ],
            ),),
          body: _screens[model.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: model.changeIndex,
            currentIndex: model.currentIndex,
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.phone_android),
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
