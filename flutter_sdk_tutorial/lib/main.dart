import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:flutter_sdk_tutorial/providers/presence.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:pubnub/pubnub.dart';
import 'providers/pubnub_instance.dart';
import 'providers/messages.dart';
import 'screens/conversation.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
//    var pubnub = PubNub(
//        defaultKeyset: Keyset(
//            subscribeKey: 'demo',
//            publishKey: 'demo',
//            userId: UserId('myUniqueUserId1')));

//    return MaterialApp(
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: MessageProvider(AppState.pubnub),
        ),
        ChangeNotifierProvider.value(
          value: PresenceProvider(AppState.pubnub),
        ),
        ChangeNotifierProvider.value(
          value: AppState.friendlyNames,
        ),
      ],
      child: MaterialApp(
        title: 'PubNub Flutter Chat',
        theme: ThemeData(
          backgroundColor: Colors.blueGrey[50],
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black12)),
          primarySwatch: Colors.blue,
        ),
        home: Conversation(),
//        home: Scaffold(
//          appBar: AppBar(
//            title:
//                Text(pubnub.instance.keysets.defaultKeyset.userId.toString()),
//          ),
//          body: const Center(
//            child: RandomWords(),
//          ),
//        ),
      ),
    );
  }
}

/*
class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    const word = "Hello Darryn";
    return ListView.builder(
      itemCount: 6000, //_suggestions.length * 2,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        //final index = i;
        if (index >= _suggestions.length) {
          _suggestions.add("List Item"); /*4*/
          _suggestions[0] = "Changed: " + Random().nextInt(100).toString();
        }
        return ListTile(
          title: Text(_suggestions[index], style: _biggerFont),
        );
      },
    );
  }
  
}
*/
