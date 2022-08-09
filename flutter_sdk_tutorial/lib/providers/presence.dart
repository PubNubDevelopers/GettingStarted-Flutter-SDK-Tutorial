import 'package:flutter/foundation.dart';
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
    //  todo loop through onlineUsers and and resolve friendly names
    String members = "";
    _onlineUsers.forEach((element) {
      if (members != "") members += ", ";
      members += friendlyNames.resolveFriendlyName(element);
    });
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
    chatSubscription.presence.listen((presenceEvent) {
      switch (presenceEvent.action) {
        case PresenceAction.join:
          _addOnlineUser(presenceEvent.uuid!.value);
          break;
        case PresenceAction.leave:
        case PresenceAction.timeout:
          _removeOnlineUser(presenceEvent.uuid!.value);
          break;
        case PresenceAction.stateChange:
          break;
        case PresenceAction.interval:
          //  'join' and 'leave' will work up to the ANNOUNCE_MAX setting (defaults to 20 users)
          //  Over ANNOUNCE_MAX, an 'interval' message is sent.  More info: https://www.pubnub.com/docs/presence/presence-events#interval-mode
          //  The below logic requires that 'Presence Deltas' be defined for the keyset, you can do this from the admin dashboard
          if (presenceEvent.join.length > 0) {
            _onlineUsers.addAll(presenceEvent.join.map((uuid) => uuid.value));
          }
          if (presenceEvent.join.length > 0) {
            _onlineUsers.removeAll(presenceEvent.leave
                .where((id) => id.value != AppState.deviceId)
                .map((uuid) => uuid.value));
          }
          notifyListeners();
          break;
        default:
          break;
      }
    });
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
    var result = await pubnub.hereNow(channels: {AppState.channelName});
    _onlineUsers.addAll(result.channels.values
        .expand((c) => c.uuids.values)
        .map((occupantInfo) => occupantInfo.uuid));

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
