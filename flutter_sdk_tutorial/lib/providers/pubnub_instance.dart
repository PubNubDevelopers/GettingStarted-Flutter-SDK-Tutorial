import 'package:pubnub/pubnub.dart';
import 'app_state.dart';

class PubNubInstance {
  late PubNub _pubnub;
  late Subscription _subscription;

  PubNub get instance => _pubnub;

  Subscription get subscription => _subscription;

  PubNubInstance() {
    //  todo What if pub / sub key have not been defined
    _pubnub = PubNub(
        defaultKeyset: Keyset(
            subscribeKey: AppState.pubnubSubscribeKey,
            publishKey: AppState.pubnubPublishKey,
            userId: UserId(AppState.deviceId!)));
    //_pubnub.channels
    //    .addChannel(pubnub_channel_name)
    //    .then((result) {});

    _subscription =
        _pubnub.subscribe(channels: {AppState.channelName}, withPresence: true);
    //_subscription.resume();

    //void unsubscribe() => _subscription.unsubscribe();
    //void resubscribe() =>
    //    _pubnub.subscribe(channels: {AppState.channelName}, withPresence: true);

    var setMetadata = [
      MembershipMetadataInput(AppState.channelName, custom: {})
    ];
    _pubnub.objects.setMemberships(setMetadata, uuid: AppState.deviceId);
  }

  dispose() async {
    print("dispose PubNub");
    //  todo unsubscribe from channel
//    await _pubnub.announceLeave(channelGroups: {pubnub_channel_name});
//    if (!_subscription.isCancelled) await _subscription.cancel();
  }

  //void announceLeave() async =>
  //    await _pubnub.announceLeave(channelGroups: {pubnub_channel_name});

  //void resume() => _subscription.resume();
}
