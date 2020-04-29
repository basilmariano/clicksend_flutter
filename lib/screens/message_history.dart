import 'package:clicksendflutter/bloc/message_history_block.dart';
import 'package:clicksendflutter/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../contants.dart';
import 'message_list.dart';

class MessageHistory extends StatefulWidget {
  static const String id = 'MessageHistoryId';

  @override
  _MessageHistoryState createState() => _MessageHistoryState();
}

class _MessageHistoryState extends State<MessageHistory> {
  MessageHistoryBloc bloc;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    bloc = MessageHistoryBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void fetchData({page: int}) async {
    showToast('Loading page $page');
    _isLoading = true;
    await bloc.fetchSmsHistory(page: page);
  }

  void loadMore() {
    if (_isLoading) return;

    if (bloc.latestSmsHistoryData.currentPage <
        bloc.latestSmsHistoryData.lastPage) {
      fetchData(page: bloc.latestSmsHistoryData.currentPage + 1);
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kMessages),
      ),
      body: RefreshIndicator(
        child: StreamBuilder<List<Message>>(
          stream: bloc.smsMessagesListStream,
          builder: (context, AsyncSnapshot<List<Message>> snapshot) {
            _isLoading = false;
            if (snapshot.hasData) {
              return MessageList(
                messages: snapshot.data,
                onLoadMoreItems: () {
                  loadMore();
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: () async {
          bloc.fetchSmsHistory(page: 1);
        },
      ),
    );
  }
}
