import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/downloaded/downloaded_view.dart';
import 'package:status_downloader/views/home/home_view.dart';
import 'package:status_downloader/views/widgets/lazy_index_stacked.dart';
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
   final PageStorageBucket bucket = PageStorageBucket();


  
  @override
  Widget build(BuildContext context) {
     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context,model, child){
        return Scaffold(
          key: _scaffoldKey,
           appBar: AppBar(
             backgroundColor: Colors.green,
             automaticallyImplyLeading: false,
            title: Text('Shared Status Downloader', style: TextStyle(
              fontSize: SizeConfig.textSize(context, 5)
            ),),
            actions: <Widget>[
           
              IconButton(
                icon: Icon(Icons.person, size: SizeConfig.xMargin(context, 5.5),),
                onPressed: () async{
                 await model.handleAuth();
                  // _scaffoldKey.currentState.openEndDrawer();

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
                      leading: Icon(Icons.wb_sunny, color: Colors.green, size: SizeConfig.xMargin(context, 5),),
                      title: Text('Night Mode', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3),
                        color: Colors.green
                      )),
                      trailing: Switch(
                        
                        activeColor: Colors.white,
                        value: false, onChanged: (bool change){

                      }),
                      
                    ),
                    Divider(),
                      ListTile(
                      leading: Icon(Icons.star, color: Colors.green, size: SizeConfig.xMargin(context, 5),),
                      title: Text('Rate on play store', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3),
                        color: Colors.green
                      )),
                      
                    ),
                     Divider(),

                     Expanded(
                      child: Container(
                        child: Center(child: Text('design', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3),
                        color: Colors.green
                      )))
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
                          child: Text('Sign Out', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3),
                        color: Colors.white
                      ))),
                    ),
                   
                  ],
                ),
              ),
            ),),
          body:  mainView(context, model),
          // bottomNavigationBar: BottomNavigationBar(
          //   onTap: model.changeIndex,
          //   currentIndex: model.currentIndex,
          //   items: [
          //   BottomNavigationBarItem(icon: Icon(Icons.phone_android, size: SizeConfig.xMargin(context, 4.5),),
          //   title: Text('Local', style: TextStyle(
          //                fontSize: SizeConfig.textSize(context, 3.5),
          //             ))),
          
          //   BottomNavigationBarItem(icon: Icon(Icons.folder_shared, size: SizeConfig.xMargin(context, 4.5),),
          //   title: Text('Shared', style: TextStyle(
          //                fontSize: SizeConfig.textSize(context, 3.5),
          //             ))),

          //   BottomNavigationBarItem(icon: Icon(Icons.file_download, size: SizeConfig.xMargin(context, 4.5),),
          //   title: Text('Downloads', style: TextStyle(
          //                fontSize: SizeConfig.textSize(context, 3.5),
          //             ))),
          // ])
        
        );
      },
      viewModelBuilder: ()=> MainViewModel() ,

    );
  }
    Widget mainView(BuildContext context, MainViewModel model) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: LazyIndexedStack(
          key: UniqueKey(),
          reuse: true,
          index: model.currentIndex,
          itemCount: _screens.length,
          itemBuilder: (_, index) => _screens[index],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
          onTap: model.changeIndex,
          selectedItemColor: Colors.green,
          currentIndex: model.currentIndex,
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.phone_android, size: SizeConfig.xMargin(context, 4.5),),
          title: Text('Local', style: TextStyle(
                       fontSize: SizeConfig.textSize(context, 3.5),
                    ))),
        
          BottomNavigationBarItem(icon: Icon(Icons.folder_shared, size: SizeConfig.xMargin(context, 4.5),),
          title: Text('Shared', style: TextStyle(
                       fontSize: SizeConfig.textSize(context, 3.5),
                    ))),

          BottomNavigationBarItem(icon: Icon(Icons.file_download, size: SizeConfig.xMargin(context, 4.5),),
          title: Text('Downloads', style: TextStyle(
                       fontSize: SizeConfig.textSize(context, 3.5),
                    ))),
        ])
        );
  }

}
