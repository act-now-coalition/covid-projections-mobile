import 'package:http/http.dart' as http;
import 'dart:html';

Future<String> getCovidActNowPage(String path) async {
  var hostname = "https://www.covidactnow.org";

  var appUrl = window.location.href;
  if (appUrl.startsWith("http://localhost")) {
    hostname = "http://localhost:8080";
  }
  var url = "$hostname$path";
  return http.read(url);
}
