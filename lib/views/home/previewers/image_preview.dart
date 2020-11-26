import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

class ImagesPreview extends StatelessWidget {
  final String imagePath;
  ImagesPreview(this.imagePath);

  @override
  Widget build(BuildContext context) {
    SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
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
                          onTap: () async {
                             MyDialogService().showLoadingDialog(context, key);
                              await model.saveFile(imagePath, true);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                              _snackbarService.showSnackbar(message: 'Image Saved',
                              duration: Duration(milliseconds:1000));
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
                    Expanded(
                       child: InkWell(
                          onTap: ()  =>model.share(imagePath, true),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.share, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Share', style: TextStyle(
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

                            await model.imageUploader(context, key, imagePath);
                             
                               },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.cloud_upload, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Upload', style: TextStyle(
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
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
