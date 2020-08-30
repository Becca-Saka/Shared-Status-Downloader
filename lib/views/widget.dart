

import 'package:flutter/material.dart';

Widget textViewCard( String hintText, TextEditingController controller, Icon prefixIcon,
 TextInputType textInputType,) => Card(
   elevation: 5,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  child: TextFormField(
    controller: controller,
    keyboardType: textInputType,
  
    decoration: InputDecoration(
    
       focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.green
        )
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.transparent
        )
      ),
      hintText: hintText,
      prefixIcon: prefixIcon
    ),
  ),);


  Widget playOverlay(videoThumb, size)=> Stack(
                      fit: StackFit.expand,
                         children: [
                            Image.memory(videoThumb,
                             fit: BoxFit.cover,
                             ),
                             Center(child: Container(
                               decoration: BoxDecoration(
                                 color: Colors.grey.withOpacity(0.5),
                                 borderRadius: BorderRadius.circular(50)
                               ),
                               child: Icon(Icons.play_arrow, size: size,)))
                      ]
                    );
                   