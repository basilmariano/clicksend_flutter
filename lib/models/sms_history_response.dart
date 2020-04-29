import 'package:clicksendflutter/models/api_response_base.dart';
import 'package:clicksendflutter/models/sms_history_data.dart';

class SmsHistoryResponse extends ApiResponseBase {
  SmsHistoryResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      print(json['data']);
      data = SmsHistoryData.fromJson(json['data']);
    }
  }
}
