import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/SearchResult.dart';
import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';

// ignore: must_be_immutable
class SongPage extends StatefulWidget {
  Items song;

  SongPage(Items song){
    this.song = song;
  }

  @override
  _SongPageState createState() => _SongPageState(song);
}

class _SongPageState extends State<SongPage> {
  PaletteColor imgMainColor;
  PaletteColor imgAccentColor;
  Items song;
  String allArtists;

  _SongPageState(Items song){
    this.song = song;
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
    return Scaffold(

      backgroundColor: imgMainColor.color.withOpacity(.5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40,),
              Text('Are you sure you want to add:',
                style: TextStyle(

                  color: imgAccentColor.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 70,),

              Image.network(
                  '${song.album.images[0].url}',
                  width: 350,
                  height: 350,
                  fit:BoxFit.contain
              ),
              SizedBox(height: 20,),
              Text('${song.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: imgAccentColor.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ),
              ),
              Text('by $allArtists',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: imgAccentColor.color,
                fontSize: 15
                ),
              ),
              SizedBox(height: 80,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Nah'),
                  ),
                  SizedBox(width: 15,),
                  RaisedButton(
                    onPressed: () {
                      addSongToQueue(song.id);
                      Navigator.pop(context);
                    },
                    child: Text('Yuh'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getArtist(Items song){
    String allArtist = '';
    int length = song.artists.length;

    for(int i = 0; i < length-1; i++)
    {
      allArtist += '${song.artists[i].name}, ';
    }
    allArtist += '${song.artists[length-1].name}';
    return allArtist;
  }

  updatePalette() async{
    PaletteGenerator generator = await PaletteGenerator.
      fromImageProvider(NetworkImage(widget.song.album.images[0].url));

    imgMainColor = generator.dominantColor;

    if(generator.lightVibrantColor != null && generator.lightVibrantColor != imgMainColor)
      imgAccentColor = generator.lightVibrantColor;
    else if(generator.darkVibrantColor != null && generator.darkVibrantColor != imgMainColor)
      imgAccentColor = generator.darkVibrantColor;
    else
      imgAccentColor = PaletteColor(Colors.white,1);
    setState(() {
    });
  }

  void addSongToQueue(String id) async{
    // set up POST request arguments
    String url = 'https://thoominspotify.com/api/party/add';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"name" : "test", "trackId" : "$id", "partyCode" : "046SQU" }';

    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // check the status code for the result
    int statusCode = response.statusCode;
    print(response.body);
    print(statusCode == 200);


  }

}// end of SongPage