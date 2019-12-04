import 'package:flutter/material.dart';
import 'package:thoomin/pages/login.dart';

void main() => runApp(MaterialApp(

  theme: ThemeData(
    primaryColor: Colors.grey[900],
    accentColor: Colors.grey[300],
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
    ),
    textTheme: TextTheme().apply(bodyColor: Colors.black),
    scaffoldBackgroundColor: Colors.grey[800],
    buttonColor: Colors.grey[600],
  ),

  initialRoute: '/',
  routes: {
    '/': (context) => Login(),
  },

));
