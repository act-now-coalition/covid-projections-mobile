// could not build mobile with dart:html
// import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Utils {
  static Future<String> getCovidActNowPage(String path) async {
    const String hostname = "https://www.covidactnow.org";

    if (isWeb()) {
      // final appUrl = window.location.href;
      // if (appUrl.startsWith("http://localhost")) {
      //   hostname = "http://localhost:8080";
      // }
    }
    final url = "$hostname$path";
    return http.read(url);
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static SystemUiOverlayStyle systemUiStyle(BuildContext context) {
    if (Utils.isDarkMode(context)) {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      );
    }

    return SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    );
  }

  static bool get isAndroid {
    // Platform not available on web
    if (isWeb()) {
      return false;
    }

    return Platform.isAndroid;
  }

  static bool get isIOS {
    // Platform not available on web
    if (isWeb()) {
      return false;
    }
    return Platform.isIOS;
  }

  static bool get isMobile {
    return isAndroid || isIOS;
  }

  static bool isWeb() {
    // Platform not available on web
    // but this constant is the current work around
    if (kIsWeb) {
      return true;
    }

    // not sure why there isn't a web choice, this might be obsolete at some point
    return !(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isWindows);
  }

  static bool isNotEmpty(dynamic input) {
    if (input == null) {
      return false;
    }

    if (input is String) {
      return input.isNotEmpty;
    }

    if (input is List) {
      return input.isNotEmpty;
    }

    print('isNotEmpty called on ${input.runtimeType}');

    return false;
  }

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }
}
