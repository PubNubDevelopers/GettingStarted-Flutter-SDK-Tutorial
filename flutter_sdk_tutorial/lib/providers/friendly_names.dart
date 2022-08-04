import 'package:flutter/foundation.dart';
import 'app_state.dart';
import 'pubnub_instance.dart';

import 'package:pubnub/pubnub.dart';

class FriendlyNamesProvider with ChangeNotifier {
  final PubNub pubnub;
  Map groupMemberDeviceIds = Map();
  String get test =>
      groupMemberDeviceIds["8D2A52FD-9C97-4B4F-8078-56DACCE34BF9"];

  FriendlyNamesProvider._(this.pubnub) {
    //_updateOnlineUsers();
  }

  String resolveFriendlyName(String deviceId) {
    if (groupMemberDeviceIds.containsKey(deviceId)) {
      return groupMemberDeviceIds[deviceId];
    } else {
      print("Could not resolve");
      print(groupMemberDeviceIds);
      return deviceId;
    }
  }

  lookupMemberName(String deviceId) async {
    if (groupMemberDeviceIds.containsKey(deviceId)) {
      //  We already have a name for this uuid
      print("Have Key: " + groupMemberDeviceIds[deviceId]);
      return;
    }
    var lookupResult = await pubnub.objects.getUUIDMetadata(uuid: deviceId);
    GetUuidMetadataResult result = lookupResult;
    groupMemberDeviceIds[deviceId] = result.metadata?.name;
    notifyListeners();
  }

  replaceMemberName(String deviceId, String newName) {
    print("replace key: " + deviceId);
    print("replace value: " + newName);
    groupMemberDeviceIds[deviceId] = newName;
    //AppState.friendlyNames.groupMemberDeviceIds[deviceId] = newName;
    print("replace member name notify listners");
    print(groupMemberDeviceIds[deviceId]);
    print(AppState.friendlyNames.groupMemberDeviceIds[deviceId]);
    notifyListeners();
  }

  FriendlyNamesProvider(PubNubInstance pn) : this._(pn.instance);
}
