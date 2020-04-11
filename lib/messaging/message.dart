import 'package:covidactnow/pages/view_region.dart';
import 'package:covidactnow/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:covidactnow/utils/map_ext.dart';

class Message {
  Message(this.title, this.body);

  Message.fromMap(Map<String, dynamic> map) {
    final notification = map.mapForKey<String, dynamic>('notification');
    final data = map.mapForKey<String, dynamic>('data');

    if (notification != null && notification['title'] != null) {
      // for onMessage
      title = notification.strForKey('title');
      body = notification.strForKey('body');
    } else if (data != null && data['title'] != null) {
      // for onResume / onLaunch
      title = data.strForKey('title');
      body = data.strForKey('body');
    }

    // get route information
    if (data != null) {
      route = data.strForKey('route');
    }

    title = title ?? 'title';
    body = body ?? 'body';
  }

  String title;
  String body;
  String route;

  void navigateToRoute(
    BuildContext context,
  ) {
    if (pageRoute != null && !pageRoute.isCurrent) {
      Navigator.push(context, pageRoute);
    }
  }

  Route<void> get pageRoute {
    if (Utils.isEmpty(route)) {
      print('route is null');
      return null;
    }

    return MaterialPageRoute<void>(
      builder: (context) => Page_ViewRegion(
        stateAbbr: route,
      ),
    );
  }
}
