import 'package:covidactnow/utils/create_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget _shareDialog(BuildContext context, Uri link) {
  return AlertDialog(
    title: const Text(
        'Copy the link and post it on social media or your webpage.'),
    content: Text(link.toString()),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: link.toString()));

          Navigator.pop(context);
        },
        child: const Text('Copy link'),
      ),
    ],
  );
}

Future<void> showShareDialog(BuildContext context, String stateAbbr) async {
  final Uri link = await createDynamicLink(stateAbbr);

  await showDialog<void>(
    context: context,
    builder: (context) => _shareDialog(context, link),
  );
}
