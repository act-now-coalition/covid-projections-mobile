import 'dart:convert';

import 'package:covidactnow/messaging/message_stream.dart';
import 'package:covidactnow/pages/view_faq.dart';
import 'package:covidactnow/pages/view_region.dart';
import 'package:covidactnow/pages/view_statelist.dart';
// import 'package:covidactnow/utils/create_dynamic_links.dart';
import 'package:covidactnow/utils/utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:url_launcher/url_launcher.dart';

import './constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      title: 'COVID ACT NOW',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: const MyHomePage(title: 'COVID ACT NOW'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final String faqDataSourceURL =
      "https://abe-today.firebaseio.com/can/faq.json";
  List<dynamic> faqData;

  @override
  void initState() {
    super.initState();
    _fetchDataSource();
    initDynamicLinks();

    if (Utils.isMobile) {
      MessageStream.listen(context);
    }
  }

  void handleDynamicLink(String path, Map<String, String> params) {
    switch (path.toLowerCase()) {
      case '/open':
        Page_ViewRegion.navigateToPage(context, params['state']);
        break;
      default:
        Navigator.pushNamed(context, path);
        break;
    }
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      handleDynamicLink(deepLink.path, deepLink.queryParameters);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink.path, deepLink.queryParameters);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<void> _fetchDataSource() async {
    faqData = jsonDecode(await http.read(faqDataSourceURL)) as List<dynamic>;
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const drawerTilePadding = EdgeInsets.only(left: 30, bottom: 2, top: 2);
    final List<Widget> tabs = [Page_ViewStatelist(), Page_ViewFAQ(faqData)];

    // get rid of status bar color on Android
    SystemChrome.setSystemUIOverlayStyle(
      Utils.systemUiStyle(context),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Image(
          image: AssetImage('assets/logo.png'),
          height: 38,
        ),
        elevation: 1,
      ),
      drawer: Drawer(
        child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.launch),
                  contentPadding: drawerTilePadding,
                  title: Text('Endorsements  ', style: H2),
                  onTap: () {
                    Navigator.of(context).pop();
                    launch("https://covidactnow.org/endorsements");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.launch),
                  contentPadding: drawerTilePadding,
                  title: Text('Announcements  ', style: H2),
                  onTap: () {
                    Navigator.of(context).pop();
                    launch("https://blog.covidactnow.org/");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.launch),
                  contentPadding: drawerTilePadding,
                  title: Text('Terms of Service  ', style: H2),
                  onTap: () {
                    Navigator.of(context).pop();
                    launch("https://covidactnow.org/terms");
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.launch),
                //   contentPadding: drawerTilePadding,
                //   title: Text('Test dynamic link', style: H2),
                //   onTap: () async {
                //     Navigator.of(context).pop();
                //     final Uri res = await createDynamicLink("CA");

                //     print(res.toString());
                //     await launch(res.toString());
                //   },
                // ),
              ],
            )),
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Data'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            title: Text('FAQ'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
    );
  }
}
