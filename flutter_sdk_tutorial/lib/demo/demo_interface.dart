import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/keys.dart';

/// IMPORTANT
/// This class is ONLY used by the PubNub interactive demo framework and can be
/// safely ignored for the tutorial
/// This class should be removed from any apps using this 'getting started' app as
/// a template
class DemoInterface {
  static const pub = 'pub-c-c8d024f7-d239-47c3-9a7b-002f346c1849';
  static const sub = 'sub-c-95fe09e0-64bb-4087-ab39-7b14659aab47';
  static String accessManagerToken = "";

  static String? identifier;

  static actionCompleted(String action) async {
    if (kIsWeb && Keys.demo) {
      if (identifier == null) {
        //print("Identifier is null");
        return;
      }

      var myJson = '{"id": "$identifier", "feature": "$action"}';
      var uriJson = Uri.encodeComponent(myJson);

      String url =
          "https://ps.pndsn.com/publish/$pub/$sub/0/demo/myCallback/$uriJson?store=0&uuid=$identifier";

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //print("Success: ${response.body}");
      } else {
        print("Fail: ${response.statusCode}");
      }
    }
  }

  static requestAccessManagerToken(String userId) async {
    try {
      const String tokenServer =
          "https://devrel-demos-access-manager.netlify.app/.netlify/functions/api/flutterchat/grant";
      http.Response response = await http.post(Uri.parse(tokenServer),
          body: jsonEncode(<String, String>{"UUID": userId}),
          headers: <String, String>{
            "Content-Type": "application/json",
          });
      if (response.statusCode == 200) {
        final Map responseData = jsonDecode(response.body);
        accessManagerToken = responseData['body']['token'];
      } else {
        print("Failed to retrieve Access Manager token: $response.statusCode");
      }
    } on Exception catch (_) {
      print('Exception requesting Access Manager Token');
    }
  }
}
