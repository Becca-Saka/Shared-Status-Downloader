import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

class MyDialogService{
  SnackbarService _snackbarService = locator<SnackbarService>();
  Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(child: Column(children: <Widget>[
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),),
                SizedBox(height: 10,),
                Text('Please wait...', style: TextStyle(color: Colors.green[800]),)
              ],),)
            ],
          ),
        );
      }

    );
  }

  Future<void> alertDialog(BuildContext context, GlobalKey key,
      String content, String title, String yes, String no, var todoYes, var todoNo) async{
    switch(await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Text(content),
          title: Text(title),
          actions: <Widget>[
            FlatButton(
                onPressed: (){Navigator.pop(context, yes);},
                child: Text(yes)),
            FlatButton(onPressed: (){Navigator.pop(context, no);}, child: Text(no)),

          ],
        );
      }
    )){
      case 1:
        break;
      case 2:
        break;
    }
  }


    Future<void> showCopyDialog(BuildContext context, GlobalKey key,
     String link) async{
     return  showGeneralDialog(
        context: context, 
        pageBuilder: (context, animation1, animation2){},
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget){
          return Transform.scale(scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              key: key,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(SizeConfig.xMargin(context, 5))),
             
              content: Builder(
              builder:(context){

                return Container(
                  height: SizeConfig.yMargin(context, 28),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: SizeConfig.xMargin(context, 15),
                              width: SizeConfig.xMargin(context, 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(SizeConfig.xMargin(context, 15)),
                                color: Colors.green
                              ),
                              child: Center(child: Icon(Icons.check,size:SizeConfig.xMargin(context, 8),color: Colors.white))),
                          ),
                           SizedBox(
                            height: SizeConfig.yMargin(context, 2),
                          ),
                          Text('Status saved! Your sharing link is ready',
                          style: TextStyle(
                            fontSize:SizeConfig.textSize(context, 4.5),
                          ),),

                           SizedBox(
                            height: SizeConfig.yMargin(context, 2),
                          ),
                          Row(
                            children: [
                               Expanded(
                              child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: Colors.green,
                      onPressed: () =>Navigator.pop(context),
                      child: Center(
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:SizeConfig.textSize(context, 4.5),
                          ),
                        ),
                      ),
                    ),
                    ),
                    SizedBox(
                      width: SizeConfig.xMargin(context, 1),
                    ),
                               Expanded(
                              child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: Colors.green,
                      onPressed:(){
                        Clipboard.setData(new ClipboardData(text: link));
                        Navigator.pop(context);
                        _snackbarService.showSnackbar(message: 'Link copied',
                        duration: Duration(milliseconds:1000)
                        );
                      },
                      child: Center(
                        child: Text(
                          'Copy link',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:SizeConfig.textSize(context, 4.5),
                          ),
                        ),
                      ),
                    ),
                               ),

                           
                            ],
                          ),
                        
                        ],
                      ),
                    ),
                  ),
                );
                                },
              ),
              
              
            ),
          ),
          );
          
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: ''
        
      
      );
      }

 }