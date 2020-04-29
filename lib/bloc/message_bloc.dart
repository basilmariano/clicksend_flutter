import 'dart:async';

import 'package:clicksendflutter/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class MessageBlock {
  final _date = BehaviorSubject<String>();
  final _status = BehaviorSubject<String>();
  final _statusColor = BehaviorSubject<String>();

  Stream<String> get date =>
      _date.stream.transform(_convertTimestampToStringDate);
  Stream<String> get status => _status.stream;
  Stream<Color> get statusColor =>
      _statusColor.stream.transform(_convertStatusColor);

  MessageBlock({this.message}) {
    _date.sink.add(message.date.toString());
    _statusColor.sink.add(message.status);
  }

  Message message;

  var _convertTimestampToStringDate =
      StreamTransformer<String, String>.fromHandlers(handleData: (d, sink) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(d) * 1000);

    String dateString = DateFormat(
      'dd MMM yyyy',
    ).format(date).toString();
    sink.add(dateString);
  });

  var _convertStatusColor =
      StreamTransformer<String, Color>.fromHandlers(handleData: (status, sink) {
    Color color;

    switch (status) {
      case 'Sent':
        color = Colors.green;
        break;
      case 'Received':
        color = Colors.blue;
        break;
      case 'Failed':
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }
    sink.add(color);
  });

  dispose() {
    _date.close();
    _status.close();
    _statusColor.close();
  }
}
