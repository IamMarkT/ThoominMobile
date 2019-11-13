import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getHelloWorld() async {

    // make the request
    Response responseT = await get('https://thoominspotify.com/api/helloworld');
    Map dataT = jsonDecode(responseT.body);

    // get properties from data
    String message = dataT['message'];
    print(message);

  }

  @override
  void initState() {
    super.initState();
    getHelloWorld();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
