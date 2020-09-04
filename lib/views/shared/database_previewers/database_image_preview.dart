import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/models/status_details.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/shared/shared_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

class DatabaseImagesPreview extends StatelessWidget {
  final StatusDetails statusDetails;
  DatabaseImagesPreview(this.statusDetails);

  @override
  Widget build(BuildContext context) {
    SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<SharedViewModel>.reactive(
      builder: (context, model, child){
        
        return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color:Colors.black, size: SizeConfig.xMargin(context, 5),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child:   Hero(
                        tag: statusDetails.url,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical:20, horizontal: 5,
                              ),
                          child:
                          
                          Image.network( statusDetails.url,
                                  fit: BoxFit.contain),
                        ),
                      ),),
                ),
                Row(
                  children: <Widget>[
                     Expanded(
                       child: InkWell(
                          onTap: () async {
                             model.copyLink(statusDetails.shareLink);
                             
                             },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.content_copy, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Copy sharing link', style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 3.5),
                              ),),
                           ],
                         ),
                                ),
                       ),
                    ),
                  
                    Expanded(
                       child: InkWell(
                          onTap: () async {
                                MyDialogService().showLoadingDialog(context, key);
                                    bool isConnected = await model.connectionService.getConnectionState();
                                    if(isConnected){
                                    await  model.saveFile(statusDetails.url, true);
                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.pop(context);
                                    _snackbarService.showSnackbar(message: 'Image Saved',
                                    duration: Duration(milliseconds:1000));
                                    }else{
                                      await Future.delayed(Duration(seconds: 1));
                                    Navigator.pop(context);
                                      _snackbarService.showSnackbar(message: 'Something went wrong, please try again',
                                    duration: Duration(milliseconds:1000));

                                    }
                             },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.save, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Save', style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 3.5),
                              ),),
                             
                           ],
                         ),
                                ),
                       ),
                    ),
                  
                    
                  ],
                )
              ],
            ),
          ));
      },
      viewModelBuilder:()=> SharedViewModel(),
    
    );
  }
}
