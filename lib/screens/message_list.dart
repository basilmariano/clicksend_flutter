import 'package:clicksendflutter/models/message.dart';
import 'package:flutter/material.dart';

import 'message_item.dart';

class MessageList extends StatelessWidget {
  MessageList({@required this.messages, this.onLoadMoreItems}) {
    _controller.addListener(scrollListener);
  }

  final List<Message> messages;
  final Function() onLoadMoreItems;
  final ScrollController _controller = new ScrollController();

  void scrollListener() {
    if (_controller.position.extentAfter <= 500) {
      onLoadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      controller: _controller,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      itemCount: messages.length,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) {
        Message message = messages[index];
        return MessageItem(message: message);
      },
    );
  }
}
