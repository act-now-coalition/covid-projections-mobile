import 'package:covidactnow/messaging/message.dart';
import 'package:flutter/material.dart';

Widget _messageDialog(BuildContext context, Message item) {
  return AlertDialog(
    content: Text(item.title),
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

Future<void> showItemDialog(BuildContext context, Message message) async {
  final bool shouldNavigate = await showDialog<bool>(
    context: context,
    builder: (_) => _messageDialog(context, message),
  );

  if (shouldNavigate == true) {
    message.navigateToRoute(context);
  }
}
