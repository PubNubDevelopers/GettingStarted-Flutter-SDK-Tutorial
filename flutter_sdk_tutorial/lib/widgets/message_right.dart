import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/models.dart';

class MessageRight extends StatelessWidget {
  final ChatMessage message;

  const MessageRight(this.message);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<FriendlyNamesProvider>(context, listen: true);
    String sender = product.resolveFriendlyName(message.uuid) + " (me)";
    Color avatarColor = Colors.blue;
    TextStyle? fontStyle = TextStyle(fontWeight: FontWeight.bold);

    //  It would look nicer if we have our own messages on the right but that\
    //  would require another layout... to keep things simple I'll just highlight
    //  messages we sent ourselves.
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: Row(
                  children: [
                    Text(
                      sender,
                      textAlign: TextAlign.right,
                      style: fontStyle,
                    ),
                    const SizedBox(width: 10), // Time
                    Text(
                      getMessageTimeStamp(int.parse(message.timetoken)),
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  message.message,
                  style: Theme.of(context).textTheme.bodyText2!.apply(
                        color: Colors.black87,
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(0, 2),
                      blurRadius: 5)
                ],
              ),
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarColor,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getMessageTimeStamp(int timetoken) => DateFormat.jm().format(
      DateTime.fromMicrosecondsSinceEpoch(timetoken ~/ 10, isUtc: true)
          .toLocal());
}
