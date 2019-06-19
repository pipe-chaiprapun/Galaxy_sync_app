import 'package:flutter/material.dart';

class TextCell extends StatelessWidget{
  final String text;
  TextCell(this.text);
@override
  Widget build(BuildContext context) {
    return Text(this.text, style: TextStyle(fontSize: 16));
  }
}