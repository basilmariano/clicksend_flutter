import 'package:clicksendflutter/models/api_response_base.dart';

import 'account.dart';

class AccountResponse extends ApiResponseBase {
  AccountResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = new Account.fromJson(json['data']);
    }
  }
}
