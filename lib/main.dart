import 'package:flutter/material.dart';
import 'package:thoomin/pages/login.dart';
import 'package:thoomin/pages/home.dart';

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

    buttonColor: Colors.grey[900],
  ),



  initialRoute: '/',
  routes: {
    '/': (context) => Login(),
    //'/home': (context) => Home(nickName, partyCode),
  },
));
