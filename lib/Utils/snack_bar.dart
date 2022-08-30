import 'package:flutter/material.dart';

import 'Colors.dart';

class AppSnackBar {
  static final AppSnackBar _instance = AppSnackBar._internal();
  factory AppSnackBar() {
    return _instance;
  }

  AppSnackBar._internal();
  void showSnackBar(String message, Function onOk,BuildContext context){
    final snackBar = SnackBar(
      duration: const Duration(seconds: 4),
      backgroundColor: PrimaryAppColor,
      content: Text(message,style: const TextStyle(fontSize: 15),),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {
          onOk.call();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}