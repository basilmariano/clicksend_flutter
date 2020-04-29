import 'dart:async';

import 'package:clicksendflutter/models/account.dart';
import 'package:clicksendflutter/resources/account_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../contants.dart';

class LoginBloc {
  final _repository = AccountRepository();
  final username = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  final _account = BehaviorSubject<Account>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<String> get usernameStream => username.stream;
  Stream<String> get passwordStream => password.stream;
  Stream<Account> get account => _account.stream;
  Stream<bool> get loading => _isLoading.stream;

  Function(String) get changePassword => password.sink.add;
  Function(String) get changeUserName => username.sink.add;
  Function(bool) get showProgressBar => _isLoading.sink.add;
  Function(Account) get setAccount => _account.sink.add;

  final _validateUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.isEmpty == false) {
      sink.add(username);
    } else {
      sink.addError(kUsernameValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.isEmpty == false) {
      sink.add(password);
    } else {
      sink.addError(kPasswordValidateMessage);
    }
  });

  bool validateFields() {
    if (username.value != null &&
        username.value.isNotEmpty &&
        password.value != null &&
        password.value.isNotEmpty) {
      return true;
    } else {
      if (username.value == null || username.value.isEmpty) {
        username.addError(kUsernameValidateMessage);
      }

      if (password.value == null || password.value.isEmpty) {
        password.addError(kPasswordValidateMessage);
      }

      return false;
    }
  }

  Future<Account> submit() {
    return _repository.fetchAccount(
        userName: username.value, password: password.value);
  }

  void dispose() async {
    await username.drain();
    username.close();
    await password.drain();
    password.close();
    await _account.drain();
    _account.close();
    await _isLoading.drain();
    _isLoading.close();
  }
}
