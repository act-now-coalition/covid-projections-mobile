import 'dart:async';

import 'package:covidactnow/messaging/message.dart';
import 'package:covidactnow/messaging/message_dialog.dart';
import 'package:covidactnow/utils/map_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageStream {
  factory MessageStream() {
    _singleton ??= MessageStream._();

    return _singleton;
  }

  MessageStream._() {
    _setup();
  }

  static MessageStream _singleton;

  FirebaseMessaging _firebaseMessaging;
  StreamController<Map<String, dynamic>> _streamController;

  Stream<Map> get stream => _streamController.stream;
  Future<String> get token => _firebaseMessaging.getToken();

  // called from main.dart to listen for notifications
  static void listen(BuildContext context) {
    final MessageStream _messageStream = MessageStream();

    _messageStream.stream.forEach((Map event) {
      switch (event.strForKey('event')) {
        case 'onMessage':
          showItemDialog(
            context,
            Message.fromMap(
              event.mapForKey<String, dynamic>('message'),
            ),
          );
          break;
        case 'onLaunch':
        case 'onResume':
        case 'onBackgroundMessage':
          final message = Message.fromMap(
            event.mapForKey<String, dynamic>('message'),
          );

          message.navigateToRoute(context);
          break;
        default:
          print('message not handled: listen() $event');
      }
    });
  }

  void _sendEvent(Map<String, dynamic> event) {
    _streamController.add(event); // Ask stream to send counter values as event.
  }

  void _setup() {
    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _sendEvent(<String, dynamic>{'event': 'onMessage', 'message': message});
      },
      onBackgroundMessage: backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _sendEvent(<String, dynamic>{'event': 'onLaunch', 'message': message});
      },
      onResume: (Map<String, dynamic> message) async {
        _sendEvent(<String, dynamic>{'event': 'onResume', 'message': message});
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });

    _firebaseMessaging.subscribeToTopic('all');

    _streamController = StreamController<Map<String, dynamic>>.broadcast(
      onListen: _handleOnListen,
      onCancel: _handleOnCancel,
    );
  }

  void _handleOnListen() {
    // print('got listen');
  }

  void _handleOnCancel() {
    // print('got got cancel');
  }
}

// global function for background messaging
Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  final stream = MessageStream();
  stream._sendEvent(
      <String, dynamic>{'event': 'onBackgroundMessage', 'message': message});

  return null;
}
