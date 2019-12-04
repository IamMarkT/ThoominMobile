import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/SearchResult.dart';
import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';

// ignore: must_be_immutable
class SongPage extends StatefulWidget {
  Items song;
  String nickName;
  String partyCode;

  SongPage(Items song, String nickName, String partyCode) {
    this.song = song;
    this.nickName = nickName;
    this.partyCode = partyCode;
  }

  @override
  _SongPageState createState() => _SongPageState(song, nickName, partyCode);
}

class _SongPageState extends State<SongPage> {
  PaletteColor imgMainColor, imgAccentColor;
  Items song;
  String nickName, partyCode, allArtists;

  _SongPageState(Items song, String nickName, String partyCode) {
    this.song = song;
    this.nickName = nickName;
    this.partyCode = partyCode;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePalette();
    allArtists = getArtist(song);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      backgroundColor: imgMainColor.color.withOpacity(.5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(80),
              ),
              Text(
                'Are you sure you want to add:',
                style: TextStyle(
                  color: imgAccentColor.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      // bottomLeft
                        offset: Offset(-.25, -.25),
                        color: Colors.black),
                    Shadow(
                      // bottomRight
                        offset: Offset(.25, -.25),
                        color: Colors.black),
                    Shadow(
                      // topRight
                        offset: Offset(.25, .25),
                        color: Colors.black),
                    Shadow(
                      // topLeft
                        offset: Offset(-.25, .25),
                        color: Colors.black),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(100),
              ),
              Image.network('${song.album.images[0].url}',
                  width: ScreenUtil.getInstance().setWidth(900),
                  height: ScreenUtil.getInstance().setHeight(900),
                  fit: BoxFit.contain),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(80),
              ),
              Text(
                '${song.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: imgAccentColor.color,
                  fontSize: 20,
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
              SizedBox(height: ScreenUtil.getInstance().setHeight(8),),

              Text(
                'by $allArtists',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: imgAccentColor.color,
                  fontSize: 15,
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
              SizedBox(height: ScreenUtil.getInstance().setHeight(150),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                  SizedBox(
                    width: ScreenUtil.getInstance().setWidth(50),
                  ),
                  RaisedButton(
                    onPressed: () {
                      addSongToQueue(song.id);
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getArtist(Items song) {
    String allArtist = '';
    int length = song.artists.length;

    for (int i = 0; i < length - 1; i++) {
      allArtist += '${song.artists[i].name}, ';
    }
    allArtist += '${song.artists[length - 1].name}';
    return allArtist;
  }

  updatePalette() async {
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.song.album.images[0].url));

    imgMainColor = generator.dominantColor;

    if (generator.vibrantColor != null &&
        generator.vibrantColor != imgMainColor)
      imgAccentColor = generator.vibrantColor;
    else if (generator.lightVibrantColor != null &&
        generator.lightVibrantColor != imgMainColor)
      imgAccentColor = generator.lightVibrantColor;
    else
      imgAccentColor = PaletteColor(Colors.white, 1);
    setState(() {});
  }

  void addSongToQueue(String id) async {
    // set up POST request arguments
    String url = 'https://thoominspotify.com/api/party/add';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"name" : "$nickName", "trackId" : "$id", "partyCode" : "$partyCode" }';

    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // check the status code for the result
    // int statusCode = response.statusCode;
    // print(response.body);
    // print(statusCode);
  }
} // end of SongPage
