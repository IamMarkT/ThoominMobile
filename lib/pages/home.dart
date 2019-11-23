import 'package:flutter/material.dart';
import 'package:thoomin/pages/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPage = 0;
  final pageOptions = [
    Search(),
    //currentlyplaying()
    SafeArea(child: Text('We THOOMIN!', style: TextStyle(fontSize: 36),)),
    SafeArea(child: Text('Landscape', style: TextStyle(fontSize: 36),)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],

      body: pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (int index){
          setState(() {
            selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search')
          ),
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
