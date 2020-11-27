import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import '../widget.dart';
import 'shared_viewmodel.dart';

class SharedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<SharedViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: model.isSignedIn
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Sort By', style: TextStyle(
                            fontSize: SizeConfig.textSize(context, 3.5),
                          )),
                          DropdownButton<String>(
                            value: model.value,
                            onChanged: model.changeValue,
                            items: model.dropDown.map((String value) {
                              return DropdownMenuItem<String>(
                                  child: Text(value, style: TextStyle(
                            fontSize: SizeConfig.textSize(context, 3.5),
                          )), value: value);
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    model.value == 'Shared By You'
                        ? Container(
                            child: model.sharedByYou.length != 0 && model.value == 'Shared By You'
                                ? Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 3,
                                        ),
                                        itemCount: model.sharedByYou.length,
                                        itemBuilder: (context, index) {
                                          bool isImage = model
                                                  .sharedByYou[index]
                                                  .fileType ==
                                              'Image';
                                          String imagePath =
                                              model.sharedByYou[index].url;
                                          final thumb =
                                              model.sharedByYou[index].thumb;
                                          return isImage
                                              ? InkWell(
                                                  onTap: () => model
                                                      .navigateToImagePreview(
                                                          model.sharedByYou[index]),
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
                                                          model.sharedByYou[index]),
                                                  child: Hero(
                                                    tag: imagePath,
                                                    child: Container(
                                                      height: 400,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: playOverlay(
                                                              base64Decode(
                                                                  thumb),
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
                                    ? CircularProgressIndicator()
                                    : Expanded(
                                        child: Center(
                                            child: Text('No Image found'))),
                          )
                        : 
                         Container(
                            child: model.sharedWithYou.length != 0
                                ? Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 3,
                                        ),
                                        itemCount: model.sharedWithYou.length,
                                        itemBuilder: (context, index) {
                                          bool isImage = model
                                                  .sharedWithYou[index]
                                                  .fileType ==
                                              'Image';
                                          String imagePath =
                                              model.sharedWithYou[index].url;
                                          final thumb =
                                              model.sharedWithYou[index].thumb;
                                          return isImage
                                              ? InkWell(
                                                  onTap: () => model
                                                      .navigateToImagePreview(
                                                          model.sharedWithYou[index]),
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
                                                          imagePath),
                                                  child: Hero(
                                                    tag: imagePath,
                                                    child: Container(
                                                      height: 400,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: playOverlay(
                                                              base64Decode(
                                                                  thumb),
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
                                    ? CircularProgressIndicator()
                                    : Expanded(
                                        child: Center(
                                            child: Text('No Image found'))),
                          ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('You need to sign in to use this feature',
                        style: TextStyle(
                            fontSize: width / 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black)),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: InkWell(
                        onTap: () => model.navigateToSignUp(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5)),
                          height: 50,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SignInView()));
                            },
                            child: Center(child: Text('Sign In')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
      viewModelBuilder: () => SharedViewModel(),
      onModelReady: (model) {
        model.getData();
        // model.createLink();
      },
    );
  }
}
