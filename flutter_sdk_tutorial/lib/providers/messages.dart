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

    //  TUTORIAL: STEP 2G CODE GOES HERE

    //  Applications receive various types of information from PubNub through a 'listener'
    //  This application dynamically registers a listener when it comes to the foreground

    //  TUTORIAL: STEP 2D CODE GOES HERE (2/2)

    //  TUTORIAL: STEP 2E CODE GOES WITHIN THE CODE COPIED ABOVE

    //  TUTORIAL: STEP 2I CODE GOES WITHIN THE CODE COPIED ABOVE (2/2)
  }
  MessageProvider(PubNubInstance pn) : this._(pn.instance, pn.subscription);

  getMessagesById(String spaceId) =>
      messages.where((message) => message.channel == spaceId).toList();

  _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  sendMessage(String channel, String message) async {
    //  TUTORIAL: STEP 2C CODE GOES HERE

    //  Interactive Demo only
    DemoInterface.actionCompleted("Send a message");
  }

  @override
  void dispose() async {
    subscription.cancel();
    super.dispose();
  }
}
