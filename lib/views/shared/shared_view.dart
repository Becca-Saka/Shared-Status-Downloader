import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'shared_viewmodel.dart';

class SharedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SharedViewModel>.nonReactive(
      builder: (context, model, child){
        return Scaffold(
          appBar: AppBar(
            title: Text('Shared with you'),
            ),
          body: Column(
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
          ),
        );
      },
      viewModelBuilder:()=> SharedViewModel(),
    );
  }
}
