import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/signin/signin_view.dart';
import 'shared_viewmodel.dart';

class SharedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<SharedViewModel>.nonReactive(
      builder: (context, model, child){
        return Scaffold(
          body: model.isSignedIn?  Column(
            children: <Widget>[
            Row(
              children: <Widget>[
                Text('data'),
                DropdownButton<String>(
                  value: model.value,
                  // hint: Text('Country'),
                  onChanged:model.changeValue,
                  items: model.dropDown.map((String value) {
                    return  DropdownMenuItem<String>(child: 
                    Text(value), value: value);
                    
                  }).toList(), 
                )
              ],
            ),
            model.value =='Images'?  Container(
                child: model.imageList.length !=0? ListView.builder(
                  itemBuilder: (context, index){
                    String imagePath = model.imageList[index];
                    return Container(
                      height: 200,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                );}):
                Expanded(child: Center(child: Text('No Image found'))),
              ):Container(
                child: model.imageList.length !=0? ListView.builder(
                  itemBuilder: (context, index){
                    String imagePath = model.imageList[index];
                    return Container(
                      height: 200,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                  );}):
                  Expanded(child: Center(child: Text('No videos found'))),
              ),    
            ],
          ):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You need to sign in to use this feature',
              style:  TextStyle(fontSize:  width/20,
               fontWeight: FontWeight.w300,  color: Colors.black)),
              
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30
                ),
                child:InkWell(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                    SignInView()));
                    },  
                    child: Container(
                    decoration: BoxDecoration(
                      
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)

                    ),
                    height: 50,
                    child: InkWell(
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                            SignInView()));
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
      viewModelBuilder:()=> SharedViewModel(),
    );
  }
}
