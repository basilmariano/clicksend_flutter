import 'package:flutter/cupertino.dart';

class Account extends ChangeNotifier {
  int userId;
  String username;
  String email;
  String accountName;

  Account.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['user_email'];
  }
}
