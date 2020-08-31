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
                icon: Icon(Icons.arrow_back, color:Colors.black),
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
                       child: IconButton(icon: Icon(Icons.content_copy),
                       onPressed: (){
                         model.copyLink(statusDetails.shareLink);

                       }),
                    ),
                    Expanded(
                       child: IconButton(icon: Icon(Icons.save),
                       onPressed: () async {
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
                       }),
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
