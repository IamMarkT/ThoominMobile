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

  @override
  void initState() {
    super.initState();
    // getSearchResult(query);
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
              currentToken.getAccessToken();
              showSearch(
                  context: context,
                  delegate: SongSearch());
            },
          ),
        ],
      ),
    );
  }
}


class SongSearch extends SearchDelegate<Tracks>{
  final recentSearch = [];
  int offset = 0;



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
      return Container();
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

                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ListTile(
                      //onTap: (){},
                      title: Text(searchOutput.tracks.items[index].name),
                      subtitle: Text(searchOutput.tracks.items[index].artists[0].name),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(searchOutput.tracks.items[index].album.images[0].url),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){},
                      ),
                    ),
                  );
                },
              ),
              persistentFooterButtons: <Widget>[
                FlatButton(
                  child: Text('Next'),
                  onPressed: (){

                  },
                ),
                FlatButton(
                  child: Text('Back'),
                ),
              ],
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      );
    }
  }

  //Text(searchOutput.tracks.items[5].name),

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

Future<void> getSearchResults(String query, int offset, String token) async {
 // currentToken.accessToken = await currentToken.getAccessToken();
  // String token = currentToken.accessToken;
  print(currentToken.accessToken);

  try {
    // make the request
    Response response = await get(
        'https://api.spotify.com/v1/search?q=$query&type=track,artist&offset=$offset&limit=20',
        headers: {HttpHeaders.authorizationHeader:
        "Bearer $token"}
    ); // enter access token after "Bearer"

    var resultMap = jsonDecode(response.body);
    print(resultMap);
    searchOutput = SearchResult.fromJson(resultMap);

    print(searchOutput.tracks.items[19].name);
  }catch (e){
    print('caught error: $e');
  }

  // get properties from data
  // String message = resultMap.toString();
  //  print(message);

} // end of getSearchResults