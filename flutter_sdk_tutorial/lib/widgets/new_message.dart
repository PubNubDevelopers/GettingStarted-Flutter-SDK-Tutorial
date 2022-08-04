import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubnub/pubnub.dart';

//import '../providers/app_data.dart';
import '../providers/app_state.dart';
import '../providers/messages.dart';

class NewMessageWidget extends StatefulWidget {
  final String spaceId;

  NewMessageWidget(this.spaceId);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  bool showEmojipicker = false;
  MessageProvider? messageProvider;
  DateTime? typingTimestamp;

  @override
  void initState() {
    super.initState();
    //_controller.addListener(_sendSignal);
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = Provider.of<MessageProvider>(context, listen: false);

    return Column(
      children: [
        //  Consumer<SignalProvider>(
        //    builder: (_, signalMessages, __) => Container(
        //      padding: const EdgeInsets.only(left: 40, bottom: 5),
        //      alignment: Alignment.centerLeft,
        //      child: TypingIndicator(getTypingIndicatorContent(signalMessages)),
        //    ),
        //  ),
        Container(
          margin: EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {
                            setState(() {
                              showEmojipicker = !showEmojipicker;
                            });
                          }),
                      Expanded(
                        child: TextField(
                          autocorrect: false,
                          enableInteractiveSelection: false,
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none),
                          onSubmitted: (value) {
                            _sendMessage();
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send), onPressed: _sendMessage)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5)
            ],
          ),
        ),
        //showEmojipicker
        //    ? Container(
        //        height: MediaQuery.of(context).size.height * .3,
        //        margin: EdgeInsets.only(bottom: 10),
        //        child: selectEmoji())
        //    : Container(),
      ],
    );
  }

//  void _sendSignal() async {
//    if (_controller.text.isEmpty) {
//      await messageProvider!.sendSignal('typing_off', widget.spaceId);
//    } else if ((typingTimestamp == null ||
//            _controller.text.length == 1 ||
//            DateTime.now().difference(typingTimestamp!).inSeconds >=
//                AppData.INDICATORTIMEOUT) &&
//        _controller.text.isNotEmpty) {
//      await messageProvider!.sendSignal('typing_on', widget.spaceId);
//      typingTimestamp = DateTime.now();
//    }
//  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await messageProvider!.sendMessage(widget.spaceId, _controller.text);
      setState(() {
        FocusScope.of(context).unfocus();
        _controller.clear();
        if (showEmojipicker) showEmojipicker = false;
      });
    } else {
      //var uuidMetadataInput = UuidMetadataInput(name: "TestDCC3");
      //var result = await messageProvider?.pubnub.objects
      //    .setUUIDMetadata(uuidMetadataInput, uuid: AppState.deviceId);
      //SetUuidMetadataResult res = result as SetUuidMetadataResult;
      //print(res.metadata.name);

    }
  }

//  String getTypingIndicatorContent(SignalProvider signalProvider) {
//    var typingString = '';
//    var spaceSignal = signalProvider.signals[widget.spaceId];
//    if (spaceSignal != null && spaceSignal.message == 'typing_on') {
//      typingString =
//          '${AppData.getUserById(spaceSignal.sender).name} is typing...';
//      signalProvider.signals
//          .removeWhere((channel, signal) => channel == widget.spaceId);
//    }
//    return typingString;
//  }
}
