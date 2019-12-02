import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:thoomin/pages/currentlyPlaying.dart';
import 'package:thoomin/services/SearchResult.dart';
import 'package:thoomin/services/AccessToken.dart';
import 'song.dart';

SearchResult searchOutput = SearchResult();
AccessToken currentToken = AccessToken();

// ignore: must_be_immutable
class Home extends StatefulWidget {
  String nickName;
  String partyCode;

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

  final pageOptions = [
    CurrentlyPlaying(),
    SafeArea(child: Text('QUEUE', style: TextStyle(fontSize: 36),)
    ),
  ];

  _HomeState(String nickName, String partyCode){
    this.nickName = nickName;
    this.partyCode = partyCode;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
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
                  delegate: SongSearch(nickName, partyCode)
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

class SongSearch extends SearchDelegate<Tracks>{
  final recentSearch = [];
  int offset = 0;

  String nickName, partyCode;

  SongSearch(String nickName, String partyCode){
    this.nickName = nickName;
    this.partyCode = partyCode;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  // DONE; WORKING CLEAR BUTTON
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // actions for app bar

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // leading icon on the left of the app bar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context)  {
    // TODO: implement buildResults
    // show some result based on the selection
    //getSearchResults(query);

    if(query.isEmpty) {
      return Container(
      );
    }else {
      return FutureBuilder(
        future: getSearchResults(query, offset, currentToken.accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: ListView.builder(
                itemCount: searchOutput.tracks.items.length,
                itemBuilder: (context, index){
                  return Card(
                    color: Colors.grey[500],
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ListTile(
                      //onTap: (){},
                      title: Text(searchOutput.tracks.items[index].name,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(searchOutput.tracks.items[index].artists[0].name,
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(searchOutput.tracks.items[index].album.images[0].url),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add,
                        color: Colors.black,),
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  SongPage(searchOutput.tracks.items[index], nickName, partyCode)
                              ),
                            );
                          },
                      ),
                    ),
                  );
                },
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show when someone searches for anything

    return Scaffold();
  }


  Future<void> getSearchResults(String query, int offset, String token) async {

    try {
      // make the request
      Response response = await get(
          'https://api.spotify.com/v1/search?q=$query&type=track,artist&offset=$offset&limit=50',
          headers: {HttpHeaders.authorizationHeader:
          "Bearer $token"}
      ); // enter access token after "Bearer"

      var resultMap = jsonDecode(response.body);
      print(resultMap); //
      searchOutput = SearchResult.fromJson(resultMap);

      print(searchOutput.tracks.items[49].name); //
    }catch (e){
      print('caught error: $e');
    }
  }
}




