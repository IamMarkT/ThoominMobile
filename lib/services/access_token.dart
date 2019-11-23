import 'package:http/http.dart';
import 'dart:convert';

class AccessToken {

  String accessToken;

  Future<String> getAccessToken() async {
    try{
      // make the request
      Response response = await get('https://thoominspotify.com/api/spotify/auth');
      Map data = jsonDecode(response.body);
     // print(data.toString());


      // get properties from data
      return accessToken = data['accessToken'];
    }

    catch (e){
      print('caught error: $e');
      return accessToken = null;
    }
  }
}
