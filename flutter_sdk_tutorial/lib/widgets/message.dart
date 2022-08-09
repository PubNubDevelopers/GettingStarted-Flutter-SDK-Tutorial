import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../providers/models.dart';
import 'message_left.dart';
import 'message_right.dart';

class Message extends StatelessWidget {
  final ChatMessage message;

  Message(this.message);
  @override
  Widget build(BuildContext context) {
    final bool me = message.uuid == AppState.deviceId;

    //  Change the alignment and look of messages from myself
    if (me) {
      return MessageRight(message);
    } else {
      return MessageLeft(message);
    }
  }
}
