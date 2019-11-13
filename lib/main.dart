import 'package:flutter/material.dart';
import 'package:thoomin/pages/login.dart';
import 'package:thoomin/pages/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => Login(),
    '/home': (context) => Home(),
  },
));






