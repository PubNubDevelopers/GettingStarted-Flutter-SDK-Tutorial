import 'package:flutter/material.dart';

class ChatTitle extends StatelessWidget {
  final String space;

  ChatTitle(this.space);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              space,
              style: TextStyle(color: Colors.black),
            ),
            Text("Description",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .apply(color: Colors.grey))
          ],
        ),
      ],
    );
  }
}
