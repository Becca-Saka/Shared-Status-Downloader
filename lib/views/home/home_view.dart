import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'home_viewmodel.dart';
import 'tabs/images_view.dart';
import 'tabs/videos_view.dart';
class HomeView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child){

        return Scaffold(
          // key: PageStorageKey('Page1'),
         
          body: Container(
            child: DefaultTabController(
              length: 2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 0.5))),
                      child: TabBar(
                        indicatorColor: Theme.of(context).buttonColor,
                        tabs: [
                          Tab(
                            child: Text('Images', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3.5),
                      )),
                          ),
                          Tab(
                            child: Text('Videos', style: TextStyle(
                         fontSize: SizeConfig.textSize(context, 3.5),
                      )),
                          )
                        ],
                      ),
                    ),
                    model.isBusy? Expanded(child: Center(child:
                    CircularProgressIndicator())):
                    model.isPermitted?
                    model.isWhatsappInstalled? Expanded(
                      child: TabBarView(
                        key: PageStorageKey('Page1'),
                        children: <Widget>[
                          ImagesView(),
                          VideosView()
                        ],
                      ),
                    ):Expanded(child: Center(child:Text('Whatsapp not installed')))
                        :
                         Expanded(
                                                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Shared Status Downloader need access to your storage',
                           textAlign: TextAlign.center,
                          style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 4.0),
                                fontWeight: FontWeight.w300,
                                color: Colors.black)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: InkWell(
                        onTap: () => model.requestStoragePermission(),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5)),
                            height: 50,
                            child: Center(child: Text('Allow')),
                        ),
                      ),
                    ),
                  ],
                ),
                         ),
       
                    ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder:()=> HomeViewModel(),
      onModelReady:(model) async {
        await model.storagePermissionChecker();
        // model.getData();

      },

    );
  }
}
