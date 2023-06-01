import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/messages.dart';

class NewMessageWidget extends StatefulWidget {
  final String spaceId;

  NewMessageWidget(this.spaceId);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  MessageProvider? messageProvider;
  DateTime? typingTimestamp;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = Provider.of<MessageProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35.0),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(1, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            autocorrect: false,
                            enableInteractiveSelection: false,
                            controller: _controller,
                            autofocus: true,
                            focusNode: myFocusNode,
                            decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none),
                            onSubmitted: (value) {
                              _sendMessage(myFocusNode);
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage1)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5)
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage1() async {
    _sendMessage(myFocusNode);
  }

  void _sendMessage(FocusNode? myFocusNode) async {
    if (_controller.text.isNotEmpty) {
      await messageProvider!.sendMessage(widget.spaceId, _controller.text);
      setState(() {
        FocusScope.of(context).unfocus();
        _controller.clear();
      });
      myFocusNode?.requestFocus();
    }
  }
}
