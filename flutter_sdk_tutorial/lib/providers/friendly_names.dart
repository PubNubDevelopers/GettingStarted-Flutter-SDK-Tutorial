import 'package:flutter/foundation.dart';
import '../utils/pubnub_instance.dart';
import 'package:pubnub/pubnub.dart';

//  This provider handles friendly names and their association with device IDs
//  If you are comparing this Flutter app with the other getting started apps
//  e.g. iOS or Kotlin, notice that this app uses a _separate_ provider
//  for presence, rather than handling everything in the same view model.
//  This was done for consistency with the existing, older Flutter sample app.

class FriendlyNamesProvider with ChangeNotifier {
  final PubNub pubnub;
  Map groupMemberDeviceIds = Map();

  FriendlyNamesProvider._(this.pubnub);

  //  The mapping of device IDs to friendly names is kept in a map in this provider
  //  Return the friendly name for a given Device Id
  String resolveFriendlyName(String deviceId) {
    if (groupMemberDeviceIds.containsKey(deviceId)) {
      return groupMemberDeviceIds[deviceId];
    } else {
      return deviceId;
    }
  }

  //  The 'master record' for each device's friendly name is stored in PubNub Object storage.
  //  This avoids the application defining its own server storage or trying to keep track of all
  //  friendly names on every device.  Since PubNub Objects understand the concept of a user name
  //  (along with other common fields like email and profileUrl), it makes the process straight forward
  lookupMemberName(String deviceId) async {
    if (groupMemberDeviceIds.containsKey(deviceId)) {
      //  We already have a name for this uuid
      return;
    }

    //  TUTORIAL: STEP 2I CODE GOES HERE (1/2)

    notifyListeners();
  }

  //  Update the hashmap of DeviceId --> friendly name mappings.
  //  Used for when names CHANGE
  replaceMemberName(String deviceId, String newName) {
    groupMemberDeviceIds[deviceId] = newName;
    notifyListeners();
  }

  FriendlyNamesProvider(PubNubInstance pn) : this._(pn.instance);
}
