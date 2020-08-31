import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';

import '../downloaded_viewmodel.dart';

class DownloadImagesPreview extends StatelessWidget {
  final String imagePath;
  DownloadImagesPreview(this.imagePath);

  @override
  Widget build(BuildContext context) {
    SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<DownloadViewModel>.reactive(
      builder: (context, model, child) {
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
                      child: Hero(
                        tag: imagePath,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 5,
                          ),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              MyDialogService().showLoadingDialog(context, key);
                              await model.saveFile(imagePath, true);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                              _snackbarService.showSnackbar(message: 'Image Saved',
                              duration: Duration(milliseconds:1000));
                             
                            
                            }
                            ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () =>model.share(imagePath, true)
                            ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.cloud_upload),
                            onPressed: () async{
                               MyDialogService().showLoadingDialog(context, key);
                              bool isConnected = await model.connectionService.getConnectionState();
                              if(isConnected){
                              String link = await model.uploadFile(true,path:imagePath);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                               await Future.delayed(Duration(milliseconds: 500));
                               MyDialogService().showCopyDialog(
                                 context, key,
                                link);
                              }else{
                                await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                                _snackbarService.showSnackbar(message: 'Something went wrong, please try again',
                              duration: Duration(milliseconds:1000));

                              }
                              
                            }
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
      viewModelBuilder: () => DownloadViewModel(),
    );
  }
}
