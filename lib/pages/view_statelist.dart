import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import './view_region.dart';

class Page_ViewStatelist extends StatelessWidget {
  String _abbreviateInt(int num) {
    final numberInMillions = num / 1000000;

    if (numberInMillions > 1) {
      return "${numberInMillions.toStringAsPrecision(2)}M";
    } else {
      return "${(numberInMillions * 1000).round()}K";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: States.length + 1,
      itemBuilder: (BuildContext bc, int index) {
        if (index == 0) {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: ourLightGrey,
              border: Border(
                left: BorderSide(
                    color: INTERVENTION_COLOR_MAP[SHELTER_IN_PLACE], width: 4),
              ),
            ),
            child: DefaultTextStyle(
              style: GoogleFonts.roboto(
                textStyle: P.merge(
                  const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Act Now.",
                        style: H1.merge(const TextStyle(color: Colors.black))),
                    const TextSpan(text: "  "),
                    TextSpan(
                        text: "Save lives.",
                        style: H1.merge(TextStyle(
                            color: ourHighlight, fontWeight: FontWeight.bold))),
                  ])),
                  Container(height: 8),
                  Text(
                      "Our projections show when hospitals will likely become overloaded, and what you can do to stop COVID.",
                      style: P),
                ],
              ),
            ),
          );
        }

        index -= 1;
        final state = States[index];
        return ListTile(
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                  builder: (context) => Page_ViewRegion(
                        stateAbbr: state["state_code"] as String,
                      )),
            );
          },
          title: Text("${state["state"]} (${state["state_code"]})",
              style: const TextStyle(color: Colors.black)),
          subtitle: RichText(
              text: TextSpan(
                  style: TextStyle(color: ourDarkGrey),
                  text: INTERVENTION_TITLES[
                      STATE_INTERVENTION[state["state_code"]]],
                  children: [
                TextSpan(text: " ● ", style: TextStyle(color: ourMediumGrey)),
                TextSpan(
                    text:
                        "${_abbreviateInt(state["population"] as int)} residents")
              ])),
        );
      },
    );
  }
}
