import 'dart:async';

import 'package:clicksendflutter/models/message.dart';
import 'package:clicksendflutter/models/sms_history_data.dart';
import 'package:clicksendflutter/resources/sms_repository.dart';

class MessageHistoryBloc {
  final repository = SmsRepository();
  final StreamController<List<Message>> _smsMessagesController =
      StreamController<List<Message>>();
  Stream<List<Message>> get smsMessagesListStream =>
      _smsMessagesController.stream;

  List<Message> _smsMessageHistoryList = List<Message>();
  SmsHistoryData latestSmsHistoryData;

  MessageHistoryBloc() {
    fetchSmsHistory(page: 1);
  }

  Future<void> fetchSmsHistory({page: int}) async {
    try {
      SmsHistoryData historyData = await repository.fetchSMSHistory(page: page);
      if (historyData.currentPage == 1) {
        _smsMessageHistoryList = historyData.messages;
      } else {
        _smsMessageHistoryList.addAll(historyData.messages);
      }
      _smsMessagesController.sink.add(_smsMessageHistoryList);
      latestSmsHistoryData = historyData;
    } catch (e) {
      print('BLOC EXCEPTION');
      print(e);
    }
  }

  void timestampToDate(int timestamp) {}

  dispose() {
    _smsMessagesController.close();
  }
}
