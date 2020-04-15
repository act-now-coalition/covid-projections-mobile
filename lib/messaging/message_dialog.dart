import 'package:covidactnow/messaging/message.dart';
import 'package:flutter/material.dart';

Widget _messageDialog(BuildContext context, Message message) {
  return AlertDialog(
    title: Text(message.title),
    content: Text(message.body),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: const Text('Close'),
      ),
      FlatButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: const Text('Show'),
      ),
    ],
  );
}

Future<void> showMessageDialog(BuildContext context, Message message) async {
  final bool clickedShow = await showDialog<bool>(
    context: context,
    builder: (context) => _messageDialog(context, message),
  );

  if (clickedShow == true) {
    message.navigateToRoute(context);
  }
}
