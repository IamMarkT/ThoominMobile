import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: imgAccentColor.color.withOpacity(.85),
        leading: BackButton(color: imgMainColor.color),
        title: Text('Back to Search',
          style: TextStyle(
            color: imgMainColor.color,
          ),
        ),
      ),
      backgroundColor: imgMainColor.color.withOpacity(.5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${song.name}',
                style: TextStyle(
                  color: imgAccentColor.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Image.network(
                  '${song.album.images[0].url}',
                  width: 350,
                  height: 350,
                  fit:BoxFit.contain
              ),
              SizedBox(height: 10,),

              Text('$allArtists',
              style: TextStyle(
                color: imgAccentColor.color,
                fontSize: 15
                ),
              ),
              SizedBox(height: 20,),

              RaisedButton(
                onPressed: () {
                },
                child: Text('Add to Queue'),
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

}// end of SongPage