import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/downloaded/downloaded_view.dart';
import 'package:status_downloader/views/home/home_view.dart';
import 'package:status_downloader/views/shared/shared_view.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'main_viewmodel.dart';

class MainView extends StatelessWidget {
    GlobalKey<State> _globalKey = new GlobalKey<State>();

   final List<Widget> _screens = [
    HomeView(),
    SharedView(),
    DownloadView()

  ];
  var _currentScreen = 0;


  
  @override
  Widget build(BuildContext context) {
     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context,model, child){
        return Scaffold(
          key: _scaffoldKey,
           appBar: AppBar(
             automaticallyImplyLeading: false,
            title: Text('Shared Status Downloader', style: TextStyle(
              fontSize: SizeConfig.textSize(context, 5)
            ),),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: (){
                  model.navigateToDownloadedView();
                  

                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: (){
                  _scaffoldKey.currentState.openEndDrawer();

                },
              ),
            
            ],
          ),
          endDrawer: Drawer(
            
            child: Container(
              // color: Colors.green,
              child: SafeArea(
                              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(Icons.wb_sunny, color: Colors.green),
                      title: Text('Night Mode', style: TextStyle(
                        color: Colors.green
                      )),
                      trailing: Switch(
                        activeColor: Colors.white,
                        value: false, onChanged: (bool change){

                      }),
                      
                    ),
                    Divider(),
                      ListTile(
                      leading: Icon(Icons.star, color: Colors.green),
                      title: Text('Rate on play store', style: TextStyle(
                        color: Colors.green
                      )),
                      
                    ),
                     Divider(),

                     Expanded(
                      child: Container(
                        child: Center(child: Text('design'))
                      ),
                    ),


                    

                    Container(
                      height: 50,
                      child: RaisedButton(
                          
                          color: Colors.red,
                          onPressed: (){
                             MyDialogService().showLoadingDialog(context, _globalKey);
                            model.doSignOut()
                            .whenComplete(() => Navigator.pop(context))
                            .whenComplete(() => Navigator.pop(context))
                          .whenComplete(() =>  Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                            SignInView())));
                             
                          },
                          child: Text('Sign Out')),
                    ),
                   
                  ],
                ),
              ),
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

            BottomNavigationBarItem(icon: Icon(Icons.file_download),
            title: Text('Downloads')),
          ])
        );
      },
      viewModelBuilder: ()=> MainViewModel() ,

    );
  }
}
