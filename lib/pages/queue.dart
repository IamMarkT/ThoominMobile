import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:core';
import 'package:thoomin/services/TrackQueue.dart';

TrackQueue queuedSongs = TrackQueue();

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
    return StreamBuilder(
      stream: getQueue(),
      builder: (context, snapshot) {
        queuedSongs = snapshot.data;
        if (snapshot.hasData) {
          return Scaffold(
           body: ListView.builder(
              itemCount: queuedSongs.tracks.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[600],
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: ListTile(
                    title: Text(queuedSongs.tracks[index].name,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(queuedSongs.tracks[index].artists[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(queuedSongs.tracks[index].image),
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


  Stream<TrackQueue> getQueue() async* {
    String url = 'https://thoominspotify.com/api/party/queuetwo';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"partyCode" : "$partyCode" }';

    try {
      // make the request
      Response response = await post(url, headers: headers, body: json);

      var resultMap = jsonDecode(response.body);
      print(resultMap);
      queuedSongs = TrackQueue.fromJson(resultMap);

      await Future.delayed(Duration(seconds: 2));
      yield queuedSongs;
      setState(() {});

    } catch (e) {
      print('caught error: $e');
      yield null;
    }
  }



}
