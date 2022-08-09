import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/presence.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'demo/demo_interface.dart';
import 'providers/messages.dart';
import 'screens/conversation.dart';
import 'utils/app_state.dart';

void main() async {
  //  Interactive Demo only
  String? identifier = Uri.base.queryParameters['identifier'];
  if (identifier != null) {
    DemoInterface.identifier = identifier;
  }
  //  End Interactive Demo only

  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black12),
                iconTheme:
                    IconThemeData(color: Color.fromARGB(255, 51, 104, 123))),
            primarySwatch: createMaterialColor(const Color(0xFF33687B)),
            iconTheme:
                const IconThemeData(color: Color.fromARGB(255, 51, 104, 123))),
        home: Conversation(),
      ),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    ;
    return MaterialColor(color.value, swatch);
  }
}
