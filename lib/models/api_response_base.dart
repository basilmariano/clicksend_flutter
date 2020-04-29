class ApiResponseBase {
  int httpCode;
  String responseCode;
  String responseMessage;
  var data;

  ApiResponseBase.fromJson(Map<String, dynamic> json) {
    httpCode = json['http_code'];
    responseCode = json['response_code'];
    responseMessage = json['response_msg'];
  }
}
