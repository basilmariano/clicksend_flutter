import 'package:clicksendflutter/models/message.dart';

class SmsHistoryData {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  List<Message> messages;

  SmsHistoryData.fromJson(Map<String, dynamic> json) {
    print(json);
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];

    if (json['data'] != null) {
      List<Message> messageList = List<Message>();
      for (var itemJson in json['data']) {
        Message message = Message.fromJson(itemJson);
        messageList.add(message);
      }
      messages = messageList;
    }
  }
}
