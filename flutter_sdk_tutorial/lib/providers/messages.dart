import 'package:flutter/foundation.dart';
import 'package:pubnub/pubnub.dart';

import '../demo/demo_interface.dart';
import '../utils/app_state.dart';
import 'models.dart';
import '../utils/pubnub_instance.dart';

export 'models.dart';

class MessageProvider with ChangeNotifier {
  final PubNub pubnub;
  final Subscription subscription;
  late List<ChatMessage> _messages;

  List<ChatMessage> get messages =>
      ([..._messages]..sort((m1, m2) => m2.timetoken.compareTo(m1.timetoken)))
          .toList();

  MessageProvider._(this.pubnub, this.subscription) {
    _messages = [];

    //  When the application is first loaded, it is common to load any recent chat messages so the user
    //  can get caught up with conversations they missed.  Every application will handle this differently
    //  but here we just load the 8 most recent messages
    var result = pubnub.batch.fetchMessages({AppState.channelName}, count: 8);
    result.then((batchHistoryResult) {
      if (batchHistoryResult.channels[AppState.channelName] != null) {
        List<BatchHistoryResultEntry> historyResults = batchHistoryResult
            .channels[AppState.channelName] as List<BatchHistoryResultEntry>;
        historyResults.forEach((element) async => {
              _addMessage(ChatMessage(
                  timetoken: '${element.timetoken}',
                  channel: AppState.channelName,
                  uuid: element.uuid.toString(),
                  message: element.message)),

              //  Look up the friendly names for any uuids found in the message persistence
              await AppState.friendlyNames
                  .lookupMemberName(element.uuid.toString())
            });
      }
    });

    //  Applications receive various types of information from PubNub through a 'listener'
    //  This application dynamically registers a listener when it comes to the foreground
    subscription.messages.listen((m) {
      if (m.messageType == MessageType.normal) {
        //  A message is received from PubNub.  This is the entry point for all messages on all
        //  channels or channel groups, though this application only uses a single channel.
        _addMessage(ChatMessage(
            timetoken: '${m.publishedAt}',
            channel: m.channel,
            uuid: m.uuid.value,
            message: m.content));

        //  Interactive Demo only
        if (m.uuid.value != AppState.deviceId) {
          DemoInterface.actionCompleted(
              "Receive a message (You might need to open a new tab)");
        }
      } else if (m.messageType == MessageType.objects) {
        //  Whenever App Context meta data is changed, an App Context event is received.
        //  See: https://www.pubnub.com/docs/chat/sdks/users/setup
        //  Use this to be notified when other users change their friendly names
        AppState.friendlyNames.replaceMemberName(
            m.payload['data']['id'].toString(),
            m.payload['data']['name'].toString());
      }
    });
  }
  MessageProvider(PubNubInstance pn) : this._(pn.instance, pn.subscription);

  getMessagesById(String spaceId) =>
      messages.where((message) => message.channel == spaceId).toList();

  _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  sendMessage(String channel, String message) async {
    await pubnub.publish(channel, message);

    //  Interactive Demo only
    DemoInterface.actionCompleted("Send a message");
  }

  @override
  void dispose() async {
    subscription.cancel();
    super.dispose();
  }
}
