import 'package:clicksendflutter/bloc/login_bloc_provider.dart';
import 'package:clicksendflutter/screens/login_screen.dart';
import 'package:clicksendflutter/screens/message_history.dart';
import 'package:flutter/material.dart';

void main() => runApp(ClickSendApp());

class ClickSendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
      child: MaterialApp(
        title: 'ClickSend Flutter',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          MessageHistory.id: (context) => MessageHistory()
        },
      ),
    );
  }
}
