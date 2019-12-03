import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/Track.dart';

Track currentSong = Track();

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: StreamBuilder(
          stream: getCurrentlyPlaying(),
            builder: (BuildContext context, AsyncSnapshot<Track> snapshot){
            currentSong = snapshot.data;
              if (snapshot.hasData)
              {
                return Container(
                  child: Column(
                    children: <Widget>[

                      Container(
                        decoration: BoxDecoration(

                          image: DecorationImage(
                              image: NetworkImage(currentSong.image),
                              fit: BoxFit.contain,

                          ),
                        ),
                        height: 300,
                        width: 300,
                      ),
                      Text('${currentSong.artists}'), // convert to array
                      Text('${currentSong.name}'),
                    ],
                  ),
                );
              }
              else
                {
                return Center(child: CircularProgressIndicator());
              }
            }
        ),
      ),
    );
  }

  Stream<Track> getCurrentlyPlaying() async* {

    String url = 'https://thoominspotify.com/api/party/playing';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"partyCode" : "D9LZWX" }';

    try {
      // make the request
      Response response = await post(url, headers: headers, body: json);

      var resultMap = jsonDecode(response.body);
      print(resultMap); //
      currentSong = Track.fromJson(resultMap);
      print(currentSong.id); //
      await Future.delayed(Duration(seconds: 5));

      yield currentSong;

      setState(() {});
    }catch (e){
      print('caught error: $e');
      yield null;
    }

  }

}

