import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/pages/song.dart';
import 'package:thoomin/services/AccessToken.dart';
import 'package:thoomin/services/SearchResult.dart';

SearchResult searchOutput = SearchResult();

class SongSearch extends SearchDelegate<Tracks> {
  String nickName, partyCode;
  AccessToken currentToken = AccessToken();

  SongSearch(String nickName, String partyCode, AccessToken currentToken) {
    this.nickName = nickName;
    this.partyCode = partyCode;
    this.currentToken = currentToken;
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
        onPressed: () {
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
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // show some result based on the selection
    //getSearchResults(query);

    if (query.isEmpty) {
      return Container(
      );
    } else {
      return FutureBuilder(
        future: getSearchResults(query, currentToken.accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: ListView.builder(
                itemCount: searchOutput.tracks.items.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[500],
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ListTile(
                      title: Text(searchOutput.tracks.items[index].name,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(searchOutput.tracks.items[index].artists[0]
                          .name,
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(searchOutput.tracks
                            .items[index].album.images[0].url),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add,
                          color: Colors.black,),
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                SongPage(
                                    searchOutput.tracks.items[index], nickName,
                                    partyCode)
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

  Future<void> getSearchResults(String query, String token) async {
    try {
      // make the request
      Response response = await get(
          'https://api.spotify.com/v1/search?q=$query&type=track,artist&offset=0&limit=50',
          headers: {HttpHeaders.authorizationHeader:
          "Bearer $token"}
      ); // enter access token after "Bearer"

      var resultMap = jsonDecode(response.body);
      searchOutput = SearchResult.fromJson(resultMap);

    } catch (e) {
      print('caught error in songSearch: $e');
    }
  }
}