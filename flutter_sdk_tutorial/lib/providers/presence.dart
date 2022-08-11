import 'package:flutter/foundation.dart';
import '../demo/demo_interface.dart';
import '../utils/app_state.dart';
import '../utils/pubnub_instance.dart';
import 'friendly_names.dart';

import 'package:pubnub/pubnub.dart';

class PresenceProvider with ChangeNotifier {
  final PubNub pubnub;
  final Subscription chatSubscription;
  final Set<String> _onlineUsers = {};

  Set<String> get onlineUsers => {..._onlineUsers};
  void updateOnlineUsers() async {
    _updateOnlineUsers();
  }

  String membersOnline(FriendlyNamesProvider friendlyNames) {
    //  loop through onlineUsers and and resolve friendly names
    String members = "";
    _onlineUsers.forEach((element) {
      if (members != "") members += ", ";
      members += friendlyNames.resolveFriendlyName(element);
    });

    //  Interactive Demo only
    if (_onlineUsers.length >= 3) {
      DemoInterface.actionCompleted("Be in a chat with 3 or more people");
    }

    return members;
  }

  int get occupancy {
    return onlineUsers.length;
  }

  PresenceProvider._(this.pubnub, this.chatSubscription) {
    _updateOnlineUsers();
    //  Be notified that a 'presence' event has occurred.  I.e. somebody has left or joined
    //  the channel.  This is similar to the earlier hereNow call but this API will only be
    //  invoked when presence information changes, meaning you do NOT have to call hereNow
    //  periodically.  More info: https://www.pubnub.com/docs/sdks/kotlin/api-reference/presence

    //  TUTORIAL: STEP 2D CODE GOES HERE (1/2)

    //  TUTORIAL: STEP 2F CODE GOES WITHIN THE CODE COPIED ABOVE (1/2)
  }
  PresenceProvider(PubNubInstance pn) : this._(pn.instance, pn.subscription);

  //  Determine who is currently chatting in the channel.  I use an ArrayList in the viewModel to present this information
  //  on the UI, managed through a couple of addMember and removeMember methods
  void _updateOnlineUsers() async {
    _onlineUsers.clear();

    //  PubNub has an API to determine who is in the room.  Use this call sparingly since you are only ever likely to
    //  need to know EVERYONE in the room when the UI is first created.
    //  The API will return an array of occupants in the channel, defined by their
    //  ID.  This application will need to look up the friendly name defined for
    //  each of these IDs (later)

    //  TUTORIAL: STEP 2F CODE GOES HERE (2/2)

    //  Resolve the friendly names of everyone found in the chat
    for (var element in _onlineUsers) {
      await AppState.friendlyNames.lookupMemberName(element);
    }

    //  I am definitely here
    await _addOnlineUser(AppState.deviceId.toString());
    notifyListeners();
  }

  Future<void> _addOnlineUser(String uuid) async {
    await AppState.friendlyNames.lookupMemberName(uuid);
    _onlineUsers.add(uuid);
    notifyListeners();
  }

  void _removeOnlineUser(String uuid) {
    if (uuid != AppState.deviceId) {
      _onlineUsers.remove((uuid));
      notifyListeners();
    }
  }
}
