import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'downloaded_viewmodel.dart';
import 'tabs/images_view.dart';
import 'tabs/videos_view.dart';
class DownloadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownloadViewModel>.reactive(
      builder: (context, model, child){

        return Scaffold(
         
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
                            child: Text('Images'),
                          ),
                          Tab(
                            child: Text('Videos'),
                          )
                        ],
                      ),
                    ),
                    model.isBusy? Expanded(child: Center(child:
                    CircularProgressIndicator())):
                    model.isPermitted?
                    model.isWhatsappInstalled? Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          ImagesView(),
                          VideosView()
                        ],
                      ),
                    ):Expanded(child: Center(child:Text('Whatsapp not installed')))
                        :Expanded(
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          Text('Status need access to storage'),
                          SizedBox(height: 20,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(child: Text('Deny',),
                                onPressed: (){
                                  //TODO:deny implementation
                                },),
                              FlatButton(child: Text('Allow',),
                                onPressed: () async{
                                  // await model.requestStoragePermission();
                                },),
                            ],
                          ),

                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder:()=> DownloadViewModel(),
      onModelReady:(model) async {
        await model.storagePermissionChecker();
        // model.getData();

      },

    );
  }
}
