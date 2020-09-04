import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

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
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
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
                        child: InkWell(
                          onTap: () => model.share(imagePath, true),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share,
                                    size: SizeConfig.xMargin(context, 6)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: SizeConfig.textSize(context, 3.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                             bool result =  await model.deleteFile(imagePath);
                           if(result){
                             Navigator.of(context).pop('deleted');
                           }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete,
                                    size: SizeConfig.xMargin(context, 6)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: SizeConfig.textSize(context, 3.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
      viewModelBuilder: () => DownloadViewModel(),
    );
  }
}
