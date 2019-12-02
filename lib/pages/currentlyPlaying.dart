import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; // it allows us to convert our json to a list
import 'package:http/http.dart' as http;

class CurrentlyPlaying extends StatefulWidget {
  @override
  _CurrentlyPlayingState createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  String link = "https://thoominspotify.com/api/spotify/track";
  String _imageURLValue, _songName;
  List<dynamic> _artistsNames;
  Map data;

  var _green = Colors.green[900];

  Future getData() async {
    http.Response response =
        await http.post(link, body: {"trackId": "3dhjNA0jGA8vHBQ1VdD6vV"});

    data = json.decode(response.body);

    setState(() {
      _imageURLValue = data["imageURL"];
      _songName = data["songName"];
      _artistsNames = data["artistsNames"];
    });

//    int len = _artistsNames.length;

//    print(_songName);
//    print(_artistsNames);
//    print(_imageURLValue);
//    print("Length of list is ${_artistsNames.length}");
    debugPrint(response.body);
//    return response;
//  print(json);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/thoominHome.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.2))))),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Container(
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          )),
          _imageURLValue != null
              ? Image.network(_imageURLValue, height: 300)
              : Container(
                  child: Text('no picture'),
                ),
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 30.0)),
            Text('${_songName}',
                style: TextStyle(fontSize: 25, color: Colors.amber)),
            Text(' - ', style: TextStyle(fontSize: 25, color: Colors.black)),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _artistsNames == null ? 0 : _artistsNames.length,
                    itemBuilder: (context, i) {
                      return Text(
                        _artistsNames[i],
                        style: TextStyle(fontSize: 25, color: Colors.blue),
                      );
                    }))
          ]),
          Container(
              child: RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Exit to menu'),
          )),
          Container(
              child: RaisedButton(
            onPressed: getData,
            child: Text('Get data from http!',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          )),
        ],
      )
    ]));
  }
}
