import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; // it allows us to convert our json to a list
import 'package:http/http.dart' as http;
import 'package:thoomin/blocs/bloc.dart';
import 'package:thoomin/blocs/provider.dart';



class SongInfo {
  String imageURLValue, songName;
  List<dynamic> artistsNames;

  SongInfo({this.imageURLValue, this.songName, this.artistsNames});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
//    print(json["artistsNames"]);
    return SongInfo(
      imageURLValue: json["imageURL"],
      songName: json["songName"],
      artistsNames: json["artistsNames"],);
  }
}

class CurrentlyPlaying extends StatelessWidget {
  CurrentlyPlaying({Key key}) : super(key: key);

  Future<SongInfo> getInfo() async {
    String link = "https://thoominspotify.com/api/spotify/track";
    final http.Response response =
        await http.post(link, body: {"trackId": "11889XJ0MjktLS5WrbxEmA"});

    Map data = json.decode(response.body);
    List<dynamic> tmp = data["artistsNames"];

    if (response.statusCode == 200) {
//      print(tmp);
      return SongInfo.fromJson(json.decode(response.body));
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
                        Text(' - ', style: TextStyle(fontSize: 30)),
                        snapshot.data.artistsNames != null
                            ? Expanded(child: Text(
                            snapshot.data.artistsNames.toString(), // or call authorNames(snapshot.data.artistsNames)
                            style: TextStyle(fontSize: 30)),)
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
//              Container(
//                child: RaisedButton(
//                  onPressed: getData,
//                  child: Text('Get data from http!',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontStyle: FontStyle.italic,
//                          fontSize: 20.0)),
//                ),),
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
                style: TextStyle(fontSize: 30),
              );
            }));
  }
}
