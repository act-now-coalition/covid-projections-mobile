import 'package:covidactnow/pages/view_region.dart';
import 'package:flutter/material.dart';
import 'package:covidactnow/utils/map_ext.dart';

class Message {
  const Message(this.title, this.body);

  Message.fromMap(Map<String, dynamic> map)
      : title = stringFromMap(map, returnTitle: true),
        body = stringFromMap(map, returnTitle: false);

  final String title;
  final String body;

  static String stringFromMap(Map<String, dynamic> map, {bool returnTitle}) {
    final notification = map.mapForKey<String, dynamic>('notification');
    final data = map.mapForKey<String, dynamic>('data');
    String title;
    String body;

    if (notification != null && notification['title'] != null) {
      // for onMessage
      title = notification.strForKey('title');
      body = notification.strForKey('body');
    } else if (data != null && data['title'] != null) {
      // for onResume / onLaunch
      title = data.strForKey('title');
      body = data.strForKey('body');
    }

    title = title ?? 'title';
    body = body ?? 'body';

    if (returnTitle) {
      return title;
    }

    return body;
  }

  void navigateToRoute(
    BuildContext context,
  ) {
    if (!route.isCurrent) {
      Navigator.push(context, route);
    }
  }

  Route<void> get route {
    return MaterialPageRoute<void>(
      builder: (context) => const Page_ViewRegion(
        stateAbbr: 'TX',
      ),
    );
  }
}
