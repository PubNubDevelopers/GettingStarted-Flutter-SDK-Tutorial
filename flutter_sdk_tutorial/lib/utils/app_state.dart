import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'keys.dart';
import '../demo/demo_interface.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:flutter_sdk_tutorial/utils/pubnub_instance.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static String? _deviceId;
  static final PubNubInstance _pubnub = PubNubInstance();
  static final FriendlyNamesProvider _friendlyNames =
      FriendlyNamesProvider(_pubnub);

  //  This application hardcodes a single channel name for simplicity.  Typically you would use separate channels for each
  //  type of conversation, e.g. each 1:1 chat would have its own channel, named appropriately.
  static const String _channelName = "group_chat";
  static String _appTitle = "Group Chat";

  static PubNubInstance get pubnub => _pubnub;
  static FriendlyNamesProvider get friendlyNames => _friendlyNames;
  static String? get deviceId => _deviceId;
  static String get channelName => _channelName;
  static String get appTitle => _appTitle;

  static init() async {
    _deviceId = await initPlatformState();
    if (Keys.demo) {
      await DemoInterface.requestAccessManagerToken(_deviceId!);
    }

    //  You need to specify a Publish and Subscribe key when configuring PubNub on the device.
    //  This application will load them from this file (See ReadMe for information on obtaining keys)
    if (Keys.pubnubPublishKey == "REPLACE WITH YOUR PUBNUB PUBLISH KEY" ||
        Keys.pubnubSubscribeKey == "REPLACE WITH YOUR PUBNUB SUBSCRIBE KEY") {
      _appTitle = "MISSING KEYS";
    }
  }

  //  Create a device-specific DeviceId to represent this device and user, so PubNub knows who is connecting.
  //  More info: https://support.pubnub.com/hc/en-us/articles/360051496532-How-do-I-set-the-UUID-
  //  All Android IDs are user-resettable but are still appropriate for use here.
  //  Setting the device ID to a random value will have a significant impact on your MAU
  //  (monthly active user) count and can therefore significantly impact your bill if you
  //  are using PubNub's MAU pricing model.
  static Future<String?> initPlatformState() async {
    String? deviceId = "Blank";
    if (kIsWeb) {
      //  On Web, assign a random user id and remember it in local storage
      const localStorageKey = "com.pubnub.gettingstarted_deviceId";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedId = prefs.getString(localStorageKey);
      if (storedId == null || Keys.demo) {
        //  No local storage found, generate a new random ID for this user
        String newId = generateRandomString(15);
        await prefs.setString(localStorageKey, newId);
        deviceId = newId;
      } else {
        deviceId = storedId;
      }
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
      //  This external library will generate a '/sys/firmware/dmi/tables/smbios_entry_point: Permission denied' error
      //  You can get around this by adding your user to the group who owns the file (according to Google)
      //  but for our purposes, I will just assign a hardcoded ID in this case.
      if (deviceId == null || deviceId == "") {
        print("Device ID on Linux was empty, assigning hardcoded ID");
        deviceId = "Linux Machine ID";
      }
    }
    //  Make deviceId alphanumeric for PubNub (best practice)
    deviceId = deviceId?.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    return deviceId;
  }

  static generateRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
