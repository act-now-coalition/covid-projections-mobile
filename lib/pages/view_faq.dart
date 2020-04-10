import 'package:covidactnow/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

class Page_ViewFAQ extends StatelessWidget {
  const Page_ViewFAQ(this.faqData);

  final List<dynamic> faqData;

  @override
  Widget build(BuildContext context) {
    final List<Widget> segments = [];

    if (faqData != null) {
      for (final section in faqData) {
        segments.add(
          Container(
            decoration: const BoxDecoration(
              color: ourLightGrey,
              border: Border(
                left: BorderSide(width: 4, color: ourHighlight),
              ),
            ),
            padding:
                const EdgeInsets.only(top: 16, bottom: 12, left: 16, right: 16),
            child: Text(section["title"] as String, style: H1),
          ),
        );

        segments.add(Container(height: 16));
        for (final question in section["children"]) {
          segments.add(Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
              child: Text(question["title"] as String, style: H2)));

          segments.add(Markdown(
            data: question["children"] as String,
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
            physics: const NeverScrollableScrollPhysics(),
            onTapLink: (url) {
              launch(url);
            },
          ));
        }
      }
    } else {
      segments.add(const Text("Loading FAQ..."));
    }

    return Container(
        color: Colors.white,
        child: ListView(
          children: segments,
        ));
  }
}
