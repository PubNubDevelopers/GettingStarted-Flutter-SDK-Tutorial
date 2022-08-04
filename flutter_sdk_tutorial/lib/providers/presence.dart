import 'package:flutter/foundation.dart';
import 'app_state.dart';
import 'pubnub_instance.dart';
import 'friendly_names.dart';

import 'package:pubnub/pubnub.dart';

class PresenceProvider with ChangeNotifier {
  final PubNub pubnub;
  final Subscription chatSubscription;
  Set<String> _onlineUsers = {};

  Set<String> get onlineUsers => {..._onlineUsers};
  void updateOnlineUsers() async {
    _updateOnlineUsers();
  }

  String membersOnline(FriendlyNamesProvider friendlyNames) {
    //  todo loop through onlineUsers and and resolve friendly names
    String members = "";
    print(friendlyNames.groupMemberDeviceIds);
    _onlineUsers.forEach((element) {
      if (members != "") members += ", ";
      members += friendlyNames.resolveFriendlyName(element);
    });
    print("Members: " + members);
    return members;
  }

  int get occupancy {
    return onlineUsers.length;
  }

  PresenceProvider._(this.pubnub, this.chatSubscription) {
    _updateOnlineUsers();
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

  void _updateOnlineUsers() async {
    print("Updating online users with herenow");
    _onlineUsers.clear();
    var result = await pubnub.hereNow(channels: {AppState.channelName});
    _onlineUsers.addAll(result.channels.values
        .expand((c) => c.uuids.values)
        .map((occupantInfo) => occupantInfo.uuid));

    //  Resolve the friendly names of everyone found in the chat
    for (var element in _onlineUsers) {
      await AppState.friendlyNames.lookupMemberName(element);
    }

    //  Add myself - comments from existing
    await _addOnlineUser(AppState.deviceId.toString());
    notifyListeners();
  }

  Future<void> _addOnlineUser(String uuid) async {
    print("Adding user: " + uuid);
    await AppState.friendlyNames.lookupMemberName(uuid);
    _onlineUsers.add(uuid);
    notifyListeners();
  }

  void _removeOnlineUser(String uuid) {
    print("Removing user: " + uuid);
    if (uuid != AppState.deviceId) {
      _onlineUsers.remove((uuid));
      notifyListeners();
    }
  }
}
