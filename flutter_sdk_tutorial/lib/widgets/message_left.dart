import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_state.dart';
import '../providers/models.dart';

class MessageLeft extends StatelessWidget {
  final ChatMessage message;

  const MessageLeft(this.message);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<FriendlyNamesProvider>(context, listen: true);
    String sender = product.resolveFriendlyName(message.uuid);
    Color avatarColor = Theme.of(context).primaryColor;
    TextStyle? fontStyle = Theme.of(context).textTheme.bodyText2;

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    topRight: Radius.circular(25),
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
        ],
      ),
    );
  }

  String getMessageTimeStamp(int timetoken) => DateFormat.jm().format(
      DateTime.fromMicrosecondsSinceEpoch(timetoken ~/ 10, isUtc: true)
          .toLocal());
}
