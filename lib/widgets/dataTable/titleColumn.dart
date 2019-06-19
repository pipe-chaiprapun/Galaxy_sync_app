import 'package:flutter/material.dart';

class TitleColumn extends StatelessWidget {
  final String text;
  TitleColumn(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(this.text, textAlign: TextAlign.center, style: TextStyle(fontSize: 16));
  }
}