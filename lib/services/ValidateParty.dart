import 'package:http/http.dart';


class ValidateParty{

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