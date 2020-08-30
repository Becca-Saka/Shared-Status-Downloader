import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';

class ImagesPreview extends StatelessWidget {
  final String imagePath;
  ImagesPreview(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
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
                            onPressed: () =>model.saveImage(imagePath)
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
                              String link = await model.uploadFile(true,path:imagePath);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                               await Future.delayed(Duration(milliseconds: 500));
                               MyDialogService().showCopyDialog(
                                 context, key,
                                link, model.copyLinkTo);
                            }
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
