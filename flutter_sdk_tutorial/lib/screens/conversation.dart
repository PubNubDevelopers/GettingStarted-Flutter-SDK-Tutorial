import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:provider/provider.dart';

//import '../widgets/endDrawer.dart';
import '../widgets/chat_body.dart';
import '../widgets/chat_title.dart';
//import '../widgets/drawer.dart';
import '../providers/app_state.dart';
import '../providers/presence.dart';
import '../providers/messages.dart';

class Conversation extends StatefulWidget {
  //static const routeName = '/conversation';
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
    var spaceId = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as String
        : null;
    //final space = AppData.getSpaceById(spaceId);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer2<PresenceProvider, FriendlyNamesProvider>(
                  builder: (_, presence, friendlyNames, __) => Text(
                    //'${presence.occupancy}',
                    //'${presence.onlineUsers}',
                    //'${friendlyNames.test}',
                    presence.membersOnline(friendlyNamesProvider),
                    //friendlyNames.groupMemberDeviceIds[AppState.deviceId],
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.people_outline),
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                })
          ],
          leading: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  }),
            ],
          ),
          title: ChatTitle(AppState.channelName),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
//        drawer: Drawer(child: AppDrawer()),
//        endDrawer: Drawer(child: EndDrawer()),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print("State change: " + state.toString());
    if (state == AppLifecycleState.paused) {
      //  Mobile only: App has gone to the background
      //  Unsubscribing and resubscribing gives faster presence updates compared to pausing and resuming
      messageProvider.pubnub.announceLeave(channels: {AppState.channelName});
      messageProvider.subscription.pause();
      //messageProvider.pubnub.unsubscribeAll();
    } else if (state == AppLifecycleState.resumed) {
      //  Mobile only: App has returned to the foreground
      //messageProvider.pubnub
      //    .subscribe(channels: {AppState.channelName}, withPresence: true);
      messageProvider.subscription.resume();
      messageProvider.pubnub
          .announceHeartbeat(channels: {AppState.channelName});
      //presenceProvider = Provider.of<PresenceProvider>(context, listen: false);
      //presenceProvider.updateOnlineUsers();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<MessageProvider>(context, listen: false).dispose();
    super.dispose();
  }
}
