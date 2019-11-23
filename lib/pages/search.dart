import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/SearchResult.dart';
import 'dart:convert';
import 'package:thoomin/services/access_token.dart';
import 'package:flutter/cupertino.dart';

SearchResult searchOutput = SearchResult();
AccessToken currentToken = AccessToken();

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  Future<void> getSearchResults() async {
    currentToken.accessToken = await currentToken.getAccessToken();
    String token = currentToken.accessToken;

    print(currentToken.accessToken);
    // String query = await getQuery();

    try {
      // make the request
      Response response = await get(
          'https://api.spotify.com/v1/search?q=kanye%20west&type=track',
          headers: {HttpHeaders.authorizationHeader:
          "Bearer $token"}
      ); // enter access token after "Bearer"

      var resultMap = jsonDecode(response.body);
      print(resultMap);
      searchOutput = SearchResult.fromJson(resultMap);

      print(searchOutput.tracks.items[5].id);
    }catch (e){
      print('caught error: $e');
    }

    // get properties from data
    // String message = resultMap.toString();
    //  print(message);

  }

  @override
  void initState() {
    super.initState();
    getSearchResults();
    //print(searchOutput.tracks.items[2].id);
    //await input.getSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                  context: context,
                  delegate: SongSearch());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            //input.getSearchResults();
            //print(input.tracks.items[5].id);
          });
        },
      ),
    );
  }
}


class SongSearch extends SearchDelegate<Tracks>{
  final recentSearch = [];

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
          print('safdfa');
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
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // show some result based on the selection


    //getSearchResults(inputQuery);
    return Container(
      height: 400,
      width: 400,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show when someone searches for anything
    final suggestionList = recentSearch;

    return ListView.builder(
      itemBuilder: (context, index)=>ListTile(
        onTap: (){
          showResults(context);
        },
        leading: Icon(Icons.music_note),
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }

}
