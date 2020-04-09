// could not build mobile with dart:html
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String> getCovidActNowPage(String path) async {
  const String hostname = "https://www.covidactnow.org";

  if (kIsWeb) {
    // final appUrl = window.location.href;
    // if (appUrl.startsWith("http://localhost")) {
    //   hostname = "http://localhost:8080";
    // }
  }
  final url = "$hostname$path";
  return http.read(url);
}
