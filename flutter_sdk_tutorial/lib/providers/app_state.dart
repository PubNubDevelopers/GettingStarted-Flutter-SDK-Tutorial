import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:flutter_sdk_tutorial/providers/pubnub_instance.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:pubnub/pubnub.dart';

class AppState {
  static String? _deviceId;
  static final PubNubInstance _pubnub = PubNubInstance();
  static final FriendlyNamesProvider _friendlyNames =
      FriendlyNamesProvider(_pubnub);
  static const pubnubPublishKey = "REPLACE WITH YOUR PUBNUB PUBLISH KEY";
  static const pubnubSubscribeKey = "REPLACE WITH YOUR PUBNUB SUBSCRIBE KEY";
  static const String _channelName = "group_chat";

  static PubNubInstance get pubnub => _pubnub;
  static FriendlyNamesProvider get friendlyNames => _friendlyNames;
  static String? get deviceId => _deviceId;
  static String get channelName => _channelName;

  static init() async {
    _deviceId = await initPlatformState();
    print("Device ID: $_deviceId");

    //  todo comments from existing
    //  todo, do this elsewhere
    //await lookupMemberName(_deviceId!);
  }

  //static addMember(String deviceId) {
  //  if (!groupMemberDeviceIds.containsKey(deviceId)) {
  //    groupMemberDeviceIds[deviceId] = deviceId;
  //  }
  //  lookupMemberName(deviceId);
  //}

  //static removeMember(String deviceId) {
  //  if (groupMemberDeviceIds.containsKey(deviceId)) {
  //    groupMemberDeviceIds.remove(deviceId);
  //  }
  //}

  static Future<String?> initPlatformState() async {
    String? deviceId = "Blank";
    if (kIsWeb) {
      //  On Web, assign a random user id
      int rand = Random().nextInt(20);
      deviceId = "User_$rand";
    } else if (Platform.isAndroid) {
      deviceId = await PlatformDeviceId.getDeviceId;
    } else if (Platform.isIOS) {
      deviceId = await PlatformDeviceId.getDeviceId;
    } else if (Platform.isMacOS) {
      deviceId = await PlatformDeviceId.getDeviceId;
    } else if (Platform.isWindows) {
      deviceId = await PlatformDeviceId.getDeviceId;
    } else if (Platform.isLinux) {
      deviceId = await PlatformDeviceId.getDeviceId;
    }
    return deviceId;
  }
}
