

import 'package:flutter/material.dart';

Widget textViewCard( String hintText, TextEditingController controller, Icon prefixIcon,
 TextInputType textInputType,) => Card(
   elevation: 5,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  child: TextField(
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