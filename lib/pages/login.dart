import 'dart:ui';

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/thoominHome.jpg'),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitHeight,
            alignment: Alignment(0.10,0),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.purple.withOpacity(.05),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                'THOOMIN',
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 50,
                   color: Colors.white,
                   letterSpacing: 1.5,
                ),
              ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Your Username',
                ),
              ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter Party Code'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


