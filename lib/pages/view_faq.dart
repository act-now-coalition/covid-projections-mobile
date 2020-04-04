import 'package:covidactnow/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

class Page_ViewFAQ extends StatelessWidget {
  List<dynamic> faqData;
  Page_ViewFAQ(this.faqData);

  @override
  Widget build(BuildContext context) {
    List<Widget> segments = [];

    if (faqData != null) {
      for (var section in faqData) {
        segments.add(Container(
            child: Text(section["title"], style: H1),
            decoration: BoxDecoration(
                color: ourLightGrey,
                border:
                    Border(left: BorderSide(width: 4, color: ourHighlight))),
            padding:
                EdgeInsets.only(top: 16, bottom: 12, left: 16, right: 16)));

        segments.add(Container(height: 16));
        for (var question in section["children"]) {
          segments.add(Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: Text(question["title"], style: H2)));

          segments.add(Markdown(
            data: question["children"],
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
            physics: NeverScrollableScrollPhysics(),
            onTapLink: (url) {
              launch(url);
            },
          ));
        }
      }
    } else {
      segments.add(Text("Loading FAQ..."));
    }

    return Container(
        color: Colors.white,
        child: ListView(
          children: segments,
        ));
  }
}
