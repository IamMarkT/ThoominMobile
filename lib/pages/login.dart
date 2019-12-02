import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:thoomin/pages/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thoomin/services/ValidateParty.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController partyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/thoominHome.jpg'),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitHeight,
            alignment: Alignment(0.10, 0),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.purple.withOpacity(.05),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: ScreenUtil.getInstance().setHeight(100)),
                  Text(
                    'THOOMIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white,
                      letterSpacing: 7,
                      shadows:<Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 15.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          color: Color.fromARGB(125, 0, 0, 255),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(140)),
                  // FormCard(),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(600),
                    decoration: BoxDecoration(
                      color: Colors.grey[900].withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Nickname',
                            ),
                            style: TextStyle(
                              fontSize: 26,
                            ),
                          ),
                          SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                          TextField(
                            textCapitalization: TextCapitalization.characters,
                            controller: partyController,
                            decoration: InputDecoration(
                              labelText: 'Enter Party Code',
                            ),
                            style: TextStyle(
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: ScreenUtil.getInstance().setHeight(380)),
                  RaisedButton(
                    color: Colors.purple[700],
                    padding: EdgeInsets.all(15),
                      child: Text(
                        "Let's get THOOMIN!",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      onPressed: () async {
                        final val = await ValidateParty().validateParty(
                            nameController.text, partyController.text);

                        if (val == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                    nameController.text, partyController.text)),
                          );
                        } else {
                           showDialog(
                              context: context,
                              builder: (BuildContext context) {
                            return  AlertDialog(
                              title: Text('Party not found!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Enter a correct Party Code.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
