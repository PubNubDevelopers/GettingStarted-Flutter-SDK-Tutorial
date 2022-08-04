import 'package:flutter/material.dart';

import '../providers/models.dart';
import 'message_list.dart';
import 'new_message.dart';

class ChatBody extends StatelessWidget {
  final String space;
  ChatBody(this.space);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blueGrey[50]),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: MessageList(space),
                ),
                NewMessageWidget(space),
              ], // Column children
            ),
          ),
        ], // Stack child
      ),
    );
  }
}
