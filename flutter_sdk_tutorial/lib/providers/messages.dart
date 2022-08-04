import 'package:flutter/foundation.dart';
import 'package:pubnub/pubnub.dart';

import 'app_state.dart';
import 'models.dart';
import 'pubnub_instance.dart';

export 'models.dart';

class MessageProvider with ChangeNotifier {
  final PubNub pubnub;
  final Subscription subscription;
  late List<ChatMessage> _messages;

  List<ChatMessage> get messages =>
      ([..._messages]..sort((m1, m2) => m2.timetoken.compareTo(m1.timetoken)))
          .toList();

  MessageProvider._(this.pubnub, this.subscription) {
    print("new message provider");

    //_messages = [...AppData.conversations!];
    //  todo reuse the above logic to load history on launch (through AppData init())
    _messages = [];

    //  Retrieve messages from history
    var result = pubnub.batch.fetchMessages({AppState.channelName}, count: 8);
    result.then((batchHistoryResult) {
      List<BatchHistoryResultEntry> historyResults = batchHistoryResult
          .channels[AppState.channelName] as List<BatchHistoryResultEntry>;
      historyResults.forEach((element) async => {
            _addMessage(ChatMessage(
                timetoken: '${element.timetoken}',
                channel: AppState.channelName,
                uuid: element.uuid.toString(),
                message: element.message)),

            //  Look up the friendly names for any uuids found in the history
            await AppState.friendlyNames
                .lookupMemberName(element.uuid.toString())
          });
    });

    subscription.messages.listen((m) {
//      print("Darryn");
      if (m.messageType == MessageType.normal) {
        _addMessage(ChatMessage(
            timetoken: '${m.publishedAt}',
            channel: m.channel,
            uuid: m.uuid.value,
            message: m.content));
      } else if (m.messageType == MessageType.objects) {
        print("Objects message");
        print(m.payload);
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
    //await pubnub.publish(channel, {'text': message});
    await pubnub.publish(channel, message);
  }

  @override
  void dispose() async {
    print("messges dispose");
    this.subscription.cancel();
    //await this.pubnub.announceLeave(channelGroups: {AppData.CHANNELGROUP});
    super.dispose();
  }
}
