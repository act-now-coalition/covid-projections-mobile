import 'dart:async';

import 'package:covidactnow/messaging/message.dart';
import 'package:covidactnow/messaging/message_dialog.dart';
import 'package:covidactnow/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/*

  To send a message, go to the firebase Cloud messaging panel

  Additional options:
    Custom data:
      click_action: FLUTTER_NOTIFICATION_CLICK
      route: <State abbr>

*/

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
  StreamController<Message> _streamController;

  Stream<Message> get stream => _streamController.stream;
  Future<String> get token => _firebaseMessaging.getToken();

  // called from main.dart to listen for notifications
  // we need a context to show the dialog and navigate
  static StreamSubscription<Message> listen(BuildContext context) {
    final MessageStream messageStream = MessageStream();

    final StreamSubscription<Message> subscription =
        messageStream.stream.listen((Message message) {
      switch (message.type) {
        case MessageType.onMessage:
          showMessageDialog(
            context,
            message,
          );
          break;
        case MessageType.onLaunch:
        case MessageType.onResume:
        case MessageType.onBackgroundMessage:
          message.navigateToRoute(context);
          break;
        default:
          break;
      }
    });

    return subscription;
  }

  void _sendEvent(Message message) {
    _streamController
        .add(message); // Ask stream to send counter values as event.
  }

  void _setup() {
    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> messageMap) async {
        _sendEvent(Message.fromMap(messageMap, MessageType.onMessage));
      },
      onBackgroundMessage: Utils.isIOS ? null : backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> messageMap) async {
        _sendEvent(Message.fromMap(messageMap, MessageType.onLaunch));
      },
      onResume: (Map<String, dynamic> messageMap) async {
        _sendEvent(Message.fromMap(messageMap, MessageType.onResume));
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });

    // if you need the token to test this device, uncomment below
    // _firebaseMessaging.getToken().then((value) => print(value));

    _firebaseMessaging.subscribeToTopic('all');

    _streamController = StreamController<Message>.broadcast();
  }
}

// global function for background messaging
Future<dynamic> backgroundMessageHandler(
    Map<String, dynamic> messageMap) async {
  final stream = MessageStream();

  stream
      ._sendEvent(Message.fromMap(messageMap, MessageType.onBackgroundMessage));

  return null;
}
