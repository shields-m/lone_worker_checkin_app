

import 'package:flutter/material.dart';

Color inputBG = Color.fromARGB(255, 235, 235, 235);

BoxDecoration menuDecoration() {
  return new BoxDecoration(
  color: inputBG,
  border: Border.all(color: Colors.green, width: 2,),
  borderRadius: BorderRadius.circular(16.0),

  boxShadow: [BoxShadow(
  color: Color.fromARGB(255, 240, 240, 240),
  spreadRadius: 1,
  blurRadius: 8,
  )],
  );
}

TextStyle titleText = new TextStyle(
  color: Colors.green,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,

);

InputDecoration getInputDecoration(String label)
{

  return new InputDecoration(
    fillColor: inputBG,
    filled: true,
    labelText: label,

    labelStyle: TextStyle(backgroundColor: inputBG),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

  );
}