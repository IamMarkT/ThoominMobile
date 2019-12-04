import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/Track.dart';
import 'package:palette_generator/palette_generator.dart';

Track currentSong = Track();

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
  String partyCode;

  NowPlaying(String partyCode){
    this.partyCode = partyCode;
  }

  @override
  _NowPlayingState createState() => _NowPlayingState(partyCode);
}

class _NowPlayingState extends State<NowPlaying> {
  PaletteColor imgAccentColor, imgMainColor;
  String partyCode;

  _NowPlayingState(String partyCode){
    this.partyCode = partyCode;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: getCurrentlyPlaying(),
            builder: (BuildContext context, AsyncSnapshot<Track> snapshot) {
              currentSong = snapshot.data;
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: imgMainColor.color.withOpacity(.5),
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(130),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(currentSong.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                          height: ScreenUtil.getInstance().setHeight(800),
                          width: ScreenUtil.getInstance().setHeight(800),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(60),
                        ),
                        Text(
                          '${currentSong.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: imgAccentColor.color,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-.5, -.5),
                                  color: Colors.black),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(.5, -.5),
                                  color: Colors.black),
                              Shadow(
                                  // topRight
                                  offset: Offset(.5, .5),
                                  color: Colors.black),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-.5, .5),
                                  color: Colors.black),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                        Text(
                          '${currentSong.artists.toString().substring(1, currentSong.artists.toString().length - 1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: imgAccentColor.color,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-.4, -.4),
                                  color: Colors.black),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(.4, -.4),
                                  color: Colors.black),
                              Shadow(
                                  // topRight
                                  offset: Offset(.4, .4),
                                  color: Colors.black),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-.4, .4),
                                  color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('No music in the Queue.'),
                      Text('Request a song so we can get THOOMIN!'),

                    ],
                ),);
              }
              else{
              return Center(child: CircularProgressIndicator());

              }
            }),
      ),
    );
  }

  Stream<Track> getCurrentlyPlaying() async* {
    String url = 'https://thoominspotify.com/api/party/playing';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"partyCode" : "$partyCode" }';

    try {
      // make the request
      Response response = await post(url, headers: headers, body: json);

      var resultMap = jsonDecode(response.body);
      currentSong = Track.fromJson(resultMap);

      await updatePalette();
      await Future.delayed(Duration(seconds: 3));

      yield currentSong;
      setState(() {});

    } catch (e) {
      print('caught error: $e');
      yield null;
    }
  }

  updatePalette() async {
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(currentSong.image));

    imgMainColor = generator.dominantColor;

    if (generator.lightVibrantColor != null &&
        generator.lightVibrantColor != imgMainColor)
      imgAccentColor = generator.lightVibrantColor;
    else if (generator.vibrantColor != null &&
        generator.vibrantColor != imgMainColor)
      imgAccentColor = generator.vibrantColor;
    else
      imgAccentColor = PaletteColor(Colors.white, 1);
  }
}
