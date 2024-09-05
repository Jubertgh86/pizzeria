import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String text, int time) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(seconds: time),
      ));
  }
}
