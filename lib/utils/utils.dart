// could not build mobile with dart:html
// import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
}
