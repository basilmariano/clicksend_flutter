import 'dart:io' show Platform;

import 'package:clicksendflutter/bloc/login_bloc.dart';
import 'package:clicksendflutter/bloc/login_bloc_provider.dart';
import 'package:clicksendflutter/models/account.dart';
import 'package:clicksendflutter/resources/account_repository.dart';
import 'package:clicksendflutter/screens/message_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreenId';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;

  String userName;
  String password;
  bool isLoading = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AccountRepository accountRepositoryRepo = AccountRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _bloc.loading,
          builder: (context, snapshot) {
            bool isLoading = false;
            if (snapshot.hasData) {
              isLoading = snapshot.data;
            }
            return LoadingOverlay(
              isLoading: isLoading,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Image.asset('images/clicksend_horizontal.png'),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Container(
                        child: Text(
                          kUsername,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: userNameField(),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        kPassword,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    passwordField(),
                    SizedBox(height: 30),
                    loginButton()
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.passwordStream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
              controller: _passwordController,
              onChanged: _bloc.changePassword,
              obscureText: true,
              decoration: decoration(kPasswordHint, snapshot.error));
        });
  }

  Widget userNameField() {
    return StreamBuilder(
        stream: _bloc.usernameStream,
        builder: (context, snapshot) {
          return TextField(
            controller: _usernameController,
            onChanged: _bloc.changeUserName,
            decoration: decoration(kUsernameHint, snapshot.error),
          );
        });
  }

  Widget loginButton() {
    return Material(
      elevation: 10,
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: MaterialButton(
        minWidth: 300,
        height: 42,
        child: Text(kLogin),
        onPressed: () {
          if (_bloc.validateFields()) {
            authenticateUser();
          }
        },
        textColor: Colors.white,
      ),
    );
  }

  InputDecoration decoration(hint, errorText) {
    const borderRadius = BorderRadius.all(Radius.circular(32.0));
    Color borderColor = Colors.grey.withAlpha(80);

    return InputDecoration(
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.0),
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.0),
          borderRadius: borderRadius,
        ));
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);

    _bloc.submit().then((value) {
      _bloc.showProgressBar(false);
      if (value is Account) {
        saveAuth().then((success) {
          if (success) {
            _passwordController.text = '';
            _usernameController.text = '';
            _bloc.changePassword('');
            _bloc.changeUserName('');

            Navigator.pushNamed(context, MessageHistory.id);
          }
        });
        _bloc.setAccount(value);
      }
    }).catchError((e) {
      print(e.toString());
      _bloc.showProgressBar(false);
      showAlertDialog(e.toString());
    });
  }

  Future<bool> saveAuth() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref
        .setString(
            'userAuth', '${_bloc.username.value}:${_bloc.password.value}')
        .whenComplete(() {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  void showAlertDialog(String message) {
    Widget dialog;

    if (Platform.isIOS) {
      dialog = CupertinoAlertDialog(
        title: Text('Oops!'),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(message),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              _passwordController.text = '';
              _bloc.changePassword('');
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else {
      dialog = AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(message),
        ),
        title: Text('Oops!'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              _passwordController.text = '';
              _bloc.changePassword('');
              Navigator.pop(context);
            },
          ),
        ],
      );
    }

    showDialog(context: context, child: dialog);
  }
}
