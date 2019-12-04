import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:thoomin/pages/nowPlaying.dart';
import 'package:thoomin/pages/queue.dart';
import 'package:thoomin/pages/songSearch.dart';
import 'package:thoomin/services/AccessToken.dart';

AccessToken currentToken = AccessToken();

// ignore: must_be_immutable
class Home extends StatefulWidget {
  String nickName, partyCode;

  Home(String nickName, String partyCode){
    this.nickName = nickName;
    this.partyCode = partyCode;
  }


  @override
  _HomeState createState() => _HomeState(nickName, partyCode);
}

class _HomeState extends State<Home> {
   String nickName;
   String partyCode;
   int selectedPage = 0;

   _HomeState(String nickName, String partyCode){
     this.nickName = nickName;
     this.partyCode = partyCode;
   }

  List<Widget> _pageOptions() => [
    NowPlaying(partyCode),
    Queue(partyCode),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageOptions = _pageOptions();
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context)
                {
                  return AlertDialog(
                    title: Text('Disconnect from Party?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('/'));
                        },
                      ),
                    ],
                  );
                });
                },
            );
          },
        ),
        title: Text("Thoomin Spotify"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              currentToken.getAccessToken();
              showSearch(
                  context: context,
                  delegate: SongSearch(nickName, partyCode, currentToken)
              );
            },
          ),
        ],
      ),
      body: pageOptions[selectedPage],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.grey[200],
        unselectedItemColor: Colors.grey[600],
        currentIndex: selectedPage,
        onTap: (int index){
          setState(() {
            selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              title: Text('Currently Playing')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              title: Text('Queue')
          ),
        ],
      ),
    );
  }
}





