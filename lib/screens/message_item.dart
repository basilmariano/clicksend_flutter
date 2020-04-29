import 'package:clicksendflutter/bloc/message_bloc.dart';
import 'package:clicksendflutter/models/message.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  MessageBlock _bloc;

  MessageItem({this.message}) {
    _bloc = MessageBlock(message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${message.apiUserName}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    dateWidget()
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('From: ${message.from}'),
                  statusWidget()
                ],
              ),
              SizedBox(height: 5),
              Text('To: ${message.to}'),
              SizedBox(height: 20),
              Text('${message.body}'),
            ],
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  Widget dateWidget() {
    return StreamBuilder<String>(
        stream: _bloc.date,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('${snapshot.data}');
          } else {
            return Text('');
          }
        });
  }

  Widget statusWidget() {
    return StreamBuilder<Color>(
        initialData: Colors.blue,
        stream: _bloc.statusColor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: StreamBuilder<String>(
                  stream: _bloc.status,
                  initialData: message.status,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}',
                          style: TextStyle(color: Colors.white));
                    } else {
                      return Text('');
                    }
                  }),
              decoration: BoxDecoration(
                  color: snapshot.data,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          }
          return Container();
        });
  }
}
