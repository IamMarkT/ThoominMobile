import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; //it allows us to convert our json to a list
import 'package:http/http.dart' as http;
//import 'package:thoomin/blocs/bloc.dart';
//import 'package:thoomin/blocs/provider.dart';

class SongInfo {
  String imageURLValue, songName;

  List<dynamic> artistsNames;

  SongInfo({this.imageURLValue, this.songName, this.artistsNames});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      imageURLValue: json["imageURL"],
      songName: json["songName"],
      artistsNames: json["artistsNames"],
    );
  }
}

class CurrentlyPlaying extends StatefulWidget {

  final trackID;

  CurrentlyPlaying({Key key, this.trackID}) : super(key: key);

  @override
  _CurrentlyPlayingState createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {

  Future<SongInfo> getInfo() async {
    String link = "https://thoominspotify.com/api/spotify/track";
    final http.Response response =
        await http.post(link, body: {"trackId": "11889XJ0MjktLS5WrbxEmA"});

    Map data = json.decode(response.body);

    if (response.statusCode == 200) {
      return SongInfo.fromJson(data);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/thoominHome.jpg'),
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
          FutureBuilder<SongInfo>(
            future: getInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Image.network(
                      snapshot.data.imageURLValue,
                      height: 300,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          snapshot.data.songName,
                          style: TextStyle(fontSize: 30),
                        ),
                        Text('-', style: TextStyle(fontSize: 30)),
                        snapshot.data.artistsNames != null
                            ? authorNames(snapshot.data.artistsNames)
                            : Expanded(
                                child: Text('author names are null',
                                    style: TextStyle(fontSize: 30))),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
          Container(
              child: RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Exit to menu'),
          )),
        ],
      )
    ]));
  }

  authorNames(List<dynamic> artistsNames) {
    return Expanded(
        flex: 1,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: artistsNames == null ? 0 : artistsNames.length,
            itemBuilder: (context, i) {
              return Text(
                artistsNames[i],
                style: TextStyle(fontSize: 30),);
            })
    );
  }
}

//Container(
//child:RaisedButton(
//onPressed:getData,
//child:Text('Getdatafromhttp!',
//style:TextStyle(
//color:Colors.white,
//fontStyle:FontStyle.italic,
//fontSize:20.0)),
//),),
