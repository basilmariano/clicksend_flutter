import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exception.dart';

class ApiBaseHelper {
  final String baseUrl = "https://rest.clicksend.com/v3";
  Map<String, String> appCustomHeaders;

  Future<dynamic> get(String url, {Map<String, dynamic> headers}) async {
    var responseJson;
    try {
      final response = await http.get(baseUrl + url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url,
      {dynamic body, Map<String, dynamic> headers}) async {
    var responseJson;
    try {
      final response = await http.post(baseUrl + url,
          body: body, headers: headers, encoding: utf8);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    print(response.body);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        throw BadRequestException(responseJson['response_msg']);
      case 401:
      case 403:
        var responseJson = json.decode(response.body.toString());
        throw UnauthorisedException(responseJson['response_msg']);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<Map<String, String>> getOtherHeaders() async {
    String auth = await userAuthHeader();
    if (auth != null) {
      print('AUTH NOT NULL :: $auth');
      var bytes = utf8.encode(auth);
      String base64Str = base64.encode(bytes);
      Map<String, String> header = {'Authorization': 'Basic $base64Str'};
      return header;
    } else {
      return null;
    }
  }

  Future<String> userAuthHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userAuth');
  }
}
