import 'package:pubnub/pubnub.dart';
import 'app_state.dart';

class PubNubInstance {
  late PubNub _pubnub;
  late Subscription _subscription;

  PubNub get instance => _pubnub;

  Subscription get subscription => _subscription;

  PubNubInstance() {
    //  Create PubNub configuration and instantiate the PubNub object, used to communicate with PubNub
    _pubnub = PubNub(
        defaultKeyset: Keyset(
            subscribeKey: AppState.pubnubSubscribeKey,
            publishKey: AppState.pubnubPublishKey,
            userId: UserId(AppState.deviceId!)));

    //  Subscribe to the pre-defined channel representing this chat group.  This will allow us to receive messages
    //  and presence events for the channel (what other users are in the room)
    _subscription =
        _pubnub.subscribe(channels: {AppState.channelName}, withPresence: true);

    //  In order to receive object UUID events (in the addListener) it is required to set our
    //  membership using the Object API.
    var setMetadata = [
      MembershipMetadataInput(AppState.channelName, custom: {})
    ];
    _pubnub.objects.setMemberships(setMetadata, uuid: AppState.deviceId);
  }

  dispose() async {}
}
