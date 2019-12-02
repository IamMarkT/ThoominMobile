import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoomin/pages/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thoomin/widgets/FormCard.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
  Future<int> validateParty(String nickName, String partyCode) async{
    // set up POST request arguments
    String url = 'https://thoominspotify.com/api/party/join';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"name" : "$nickName", "partyCode" : "$partyCode" }';

    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // check the status code for the result
    int statusCode = response.statusCode;
    print(response.body);

    return statusCode;
  }
}

class _LoginState extends State<Login> {

  TextEditingController nameController = new TextEditingController();
  TextEditingController partyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: ScreenUtil.getInstance().setHeight(80)),
                  Text(
                  'THOOMIN',
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 50,
                     color: Colors.white,
                     letterSpacing: 7,
                  ),
                ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(150)),
                 // FormCard(),
                 TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Nickname',

                  ),
                ),
                  SizedBox(height: 40),
                  TextField(
                    controller: partyController,

                    decoration: InputDecoration(
                        labelText: 'Enter Party Code',
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(500)),
                  RaisedButton(
                    child: Text("Let's get THOOMIN",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                      onPressed: () async {
                        final val = await Login().validateParty(
                            nameController.text, partyController.text
                        );
                        print(nameController.text);
                        print(partyController.text);
                        print(val);

                        if(val == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home(
                                nameController.text, partyController.text)
                            ),
                          );
                        }else{
                          // alert dialog/ party not found
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );


  }

}


