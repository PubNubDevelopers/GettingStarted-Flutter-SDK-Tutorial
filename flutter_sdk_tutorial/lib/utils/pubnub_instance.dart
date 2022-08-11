import 'package:pubnub/pubnub.dart';
import 'app_state.dart';

class PubNubInstance {
  late PubNub _pubnub;
  late Subscription _subscription;

  PubNub get instance => _pubnub;

  Subscription get subscription => _subscription;

  PubNubInstance() {
    //  Create PubNub configuration and instantiate the PubNub object, used to communicate with PubNub

    //  TUTORIAL: STEP 2A CODE GOES HERE

    //  Subscribe to the pre-defined channel representing this chat group.  This will allow us to receive messages
    //  and presence events for the channel (what other users are in the room)

    //  TUTORIAL: STEP 2B CODE GOES HERE (1/2)

    //  In order to receive object UUID events (in the addListener) it is required to set our
    //  membership using the Object API.
    var setMetadata = [
      MembershipMetadataInput(AppState.channelName, custom: {})
    ];
    _pubnub.objects.setMemberships(setMetadata, uuid: AppState.deviceId);
  }

  dispose() async {}
}
