import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Toastmsg(txt){
  Fluttertoast.showToast(
      msg: "${txt}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}