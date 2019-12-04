import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/services/Track.dart';
import 'dart:core';

List<Track> queuedSongs = List<Track>();

class Queue extends StatefulWidget {
  String partyCode;

  Queue(String partyCode){
    this.partyCode = partyCode;
  }

  @override
  _QueueState createState() => _QueueState(partyCode);
}

class _QueueState extends State<Queue> {
  String partyCode;

  _QueueState(String partyCode){
    this.partyCode = partyCode;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getQueue(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
           body: ListView.builder(
              itemCount: queuedSongs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[500],
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: ListTile(
                    title: Text(queuedSongs[index].name,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(queuedSongs[index].artists[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(queuedSongs[index].image),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.queue_music,
                        color: Colors.black,),
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


  Future<List<Track>> getQueue() async {
    String url = 'https://thoominspotify.com/api/party/queue';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"partyCode" : "$partyCode" }';

    try {
      // make the request
      Response response = await post(url, headers: headers, body: json);

      var resultMap = jsonDecode(response.body);
      print(resultMap);

      //resultMap.map((m)=>Track.fromJson(m)).;

      queuedSongs = resultMap.map<Track>((t)=>Track.fromJson(t));
      //szxngy
      return queuedSongs;

    } catch (e) {
      print('caught error: $e');
      return null;
    }
  }



}
