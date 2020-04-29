class Message {
  String direction;
  int date;
  String to;
  String body;
  String status;
  String from;
  String schedule;
  String messageId;
  String firstName;
  String lastName;
  String apiUserName;

  Message.fromJson(Map<String, dynamic> json) {
    direction = json['direction'];
    date = json['date'];
    to = json['to'];
    body = json['body'];
    status = json['status'];
    from = json['from'];
    schedule = json['schedule'];
    messageId = json['messageId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    apiUserName = json['_api_username'];
  }
}
