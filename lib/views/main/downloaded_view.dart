import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import '../widget.dart';
import 'main_viewmodel.dart';

class DownloadedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
                  children: <Widget>[ Container(
                            child: model.statusVideoes.length != 0 
                                ? Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 3,
                                        ),
                                        itemCount: model.statusVideoes.length,
                                        itemBuilder: (context, index) {
                                          bool isImage = model
                                                  .statusVideoes[index]
                                                  .thumb == null;
                                          String imagePath =
                                              model.statusVideoes[index].path;
                                          final thumb =
                                              model.statusVideoes[index].thumb;
                                          return isImage
                                              ? InkWell(
                                                  onTap: () => model
                                                      .navigateToImagePreview(imagePath),
                                                  child: Hero(
                                                    tag: imagePath,
                                                    child: Container(
                                                      height: 400,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.network(
                                                            imagePath,
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () => model
                                                      .navigateToVideoPreview(
                                                          model.statusVideoes[index]),
                                                  child: Hero(
                                                    tag: imagePath,
                                                    child: Container(
                                                      height: 400,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: playOverlay(
                                                             thumb,
                                                              SizeConfig
                                                                  .xMargin(
                                                                      context,
                                                                      10))),
                                                    ),
                                                  ),
                                                );
                                        }),
                                  )
                                : model.isBusy
                                    ? Center(child: CircularProgressIndicator())
                                    : Expanded(
                                        child: Center(
                                            child: Text('No File found'))),
                          )
                      ],
                )
              
        );
      },
      viewModelBuilder: () => MainViewModel(),
      onModelReady: (model) async {
       await model.getAllStatus();
       await model.getThumbNails();
        
        // model.createLink();
      },
    );
  }
}
