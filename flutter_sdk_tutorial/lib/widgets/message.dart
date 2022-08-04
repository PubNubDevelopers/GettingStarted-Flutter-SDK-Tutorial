import 'package:flutter/material.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../providers/models.dart';

//import '../providers/app_data.dart';

class Message extends StatelessWidget {
  final ChatMessage message;

  Message(this.message);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<FriendlyNamesProvider>(context, listen: true);
    //  todo change this as appropriate
    final sender = product.resolveFriendlyName(message.uuid);
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                    offset: Offset(0, 2),
                    blurRadius: 5)
              ],
            ),
            child: CircleAvatar(
                //  todo - blank image
                //backgroundImage: NetworkImage(""),
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
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(width: 10), // Time
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
                margin: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  //message.message['text'],
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

  String getMessageTimeStamp(int timetoken) =>
      '${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(timetoken ~/ 10, isUtc: true).toLocal())}';
}
