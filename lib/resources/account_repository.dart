import 'dart:convert';

import 'package:clicksendflutter/models/account.dart';
import 'package:clicksendflutter/models/account_response.dart';
import 'package:clicksendflutter/resources/repository_base.dart';

class AccountRepository extends RepositoryBase {
  Future<Account> fetchAccount({userName: String, password: String}) async {
    String credentials = "$userName:$password";
    var bytes = utf8.encode(credentials);
    String base64Str = base64.encode(bytes);
    Map<String, String> header = {'Authorization': 'Basic $base64Str'};

    final response = await apiBaseHelper.get('/account', headers: header);
    AccountResponse r = AccountResponse.fromJson(response);
    return r.data as Account;
  }
}
