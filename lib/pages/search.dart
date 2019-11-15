import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:thoomin/services/searchSpotify.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  void getHelloWorld() async {
    // make the request
    Response responseT = await get('https://api.spotify.com/v1/search?q=Muse&type=track%2Cartist');
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
    return Container();
  }
}
