import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../widgets/chat_body.dart';
import '../widgets/chat_title.dart';
import '../providers/presence.dart';
import '../providers/messages.dart';
import '../widgets/friendly_name.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation>
    with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var messageProvider;
  var presenceProvider;
  var friendlyNamesProvider;

  @override
  Widget build(BuildContext context) {
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    presenceProvider = Provider.of<PresenceProvider>(context, listen: false);
    friendlyNamesProvider =
        Provider.of<FriendlyNamesProvider>(context, listen: false);

    //  Header to hold the current friendly name of the device along with other devices in the group chat
    //  The below logic will launch the settings activity when the option is selected
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ChatTitle(AppState.appTitle),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, bottom: 5.0, top: 5.0, right: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Members Online: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Flexible(
                        child:
                            Consumer2<PresenceProvider, FriendlyNamesProvider>(
                          builder: (_, presence, friendlyNames, __) => Text(
                            presence.membersOnline(friendlyNamesProvider),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ]),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Consumer<FriendlyNamesProvider>(
                      builder: (_, friendlyNames, __) => FriendlyNameWidget())),
            ]),
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Consumer<FriendlyNamesProvider>(
                builder: (_, friendlyNames, __) =>
                    ChatBody(AppState.channelName))));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  //  This application is designed to "unsubscribe" from the channel when it goes to the background and "re-subscribe"
  //  when it comes to the foreground.  This is a fairly common design pattern.  In production, you would probably
  //  also use a native push message to alert the user whenever there are missed messages.  For more information
  //  see https://www.pubnub.com/tutorials/push-notifications/
  //  Note that the Dart API uses slightly different terminology / behaviour to unsubscribe / re-subscribe.
  //  Note: This getting started application is set up to unsubscribe from all channels when the app goes into the background.
  //  This is good to show the principles of presence but you don't need to do this in a production app if it does not fit your use case.

  //  TUTORIAL: STEP 2B CODE GOES HERE (2/2)

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<MessageProvider>(context, listen: false).dispose();
    super.dispose();
  }
}
