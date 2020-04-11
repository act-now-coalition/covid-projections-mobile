import 'dart:convert';
import 'dart:math' as math;

import 'package:covidactnow/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class ModelDaySnapshot implements Comparable<dynamic> {
  ModelDaySnapshot();

  double Index;
  String Date;
  double EffectiveR0;
  double BeginningSusceptible;
  double NewInfected;
  double CurrentInfected;
  double RecoveredOrDied;
  double EndingSusceptible;
  double ActualReported;
  double PredictedHospitalized;
  double CumulativeInfected;
  double CumulativeDeaths;
  double AvailableHospitalBeds;
  double ValueOfSP500;
  double EstimatedActualChanceOfInfection;
  double PredictedChanceOfInfection;
  double CumulativePredictedChanceOfInfection;
  double Susceptible;
  double ChecksumR0;
  double Unknown;

  void load(
      double Index,
      String Date,
      double EffectiveR0,
      double BeginningSusceptible,
      double NewInfected,
      double CurrentInfected,
      double RecoveredOrDied,
      double EndingSusceptible,
      double ActualReported,
      double PredictedHospitalized,
      double CumulativeInfected,
      double CumulativeDeaths,
      double AvailableHospitalBeds,
      double ValueOfSP500,
      double EstimatedActualChanceOfInfection,
      double PredictedChanceOfInfection,
      double CumulativePredictedChanceOfInfection,
      double Susceptible,
      double ChecksumR0,
      double Unknown) {
    this.Index = Index;
    this.Date = Date;
    this.EffectiveR0 = EffectiveR0;
    this.BeginningSusceptible = BeginningSusceptible;
    this.NewInfected = NewInfected;
    this.RecoveredOrDied = RecoveredOrDied;
    this.EndingSusceptible = EndingSusceptible;
    this.ActualReported = ActualReported;
    this.PredictedHospitalized = PredictedHospitalized;
    this.CumulativeInfected = CumulativeInfected;
    this.CumulativeDeaths = CumulativeDeaths;
    this.AvailableHospitalBeds = AvailableHospitalBeds;
    this.ValueOfSP500 = ValueOfSP500;
    this.EstimatedActualChanceOfInfection = EstimatedActualChanceOfInfection;
    this.PredictedChanceOfInfection = PredictedChanceOfInfection;
    this.CumulativePredictedChanceOfInfection =
        CumulativePredictedChanceOfInfection;
    this.Susceptible = Susceptible;
    this.ChecksumR0 = ChecksumR0;
    this.Unknown = Unknown;
  }

  @override
  int compareTo(dynamic other) {
    if (other is ModelDaySnapshot) {
      return Index.round() - other.Index.round();
    } else {
      return 0;
    }
  }
}

class ResistBotScenarioSnapshot {
  ResistBotScenarioSnapshot(
      {this.cumulativeAffected,
      this.overloadedHospitals,
      this.estimatedDeaths});

  final String cumulativeAffected;
  final String overloadedHospitals;
  final String estimatedDeaths;
}

class ResistBotSnapshot {
  ResistBotSnapshot(
      {this.lockdown,
      this.noAction,
      this.shelterInPlace,
      this.socialDistancing,
      this.noReturnRangeEnd,
      this.noReturnRangeStart,
      this.socialDistancingNoReturnRangeEnd,
      this.socialDistancingNoReturnRangeStart});

  final ResistBotScenarioSnapshot noAction;
  final ResistBotScenarioSnapshot lockdown;
  final ResistBotScenarioSnapshot shelterInPlace;
  final ResistBotScenarioSnapshot socialDistancing;

  final String noReturnRangeEnd;
  final String noReturnRangeStart;
  final String socialDistancingNoReturnRangeStart;
  final String socialDistancingNoReturnRangeEnd;
}

class Page_ViewRegion extends StatefulWidget {
  const Page_ViewRegion({Key key, @required this.stateAbbr}) : super(key: key);

  final String stateAbbr;

  // static helper to navigate to this page
  static void navigateToPage(BuildContext context, String stateAbbr) {
    if (Utils.isNotEmpty(stateAbbr)) {
      final route = MaterialPageRoute<void>(
        builder: (context) => Page_ViewRegion(
          stateAbbr: stateAbbr,
        ),
      );

      if (!route.isCurrent) {
        Navigator.push(context, route);
      }
    }
  }

  @override
  _Page_ViewRegion createState() => _Page_ViewRegion();
}

class _Page_ViewRegion extends State<Page_ViewRegion> {
  List<charts.Series<ModelDaySnapshot, DateTime>> _lineData = [];
  ResistBotSnapshot _resistBotSnapshot;
  DateTime _overloadDate;
  DateTime _selectionDate;
  int _selectionIndex;
  final List<DateTime> _modelOverloads = [];
  List<List<ModelDaySnapshot>> _models = [];

  @override
  void initState() {
    super.initState();

    _loadModels();
    _loadResistBot();
  }

  Future<void> _loadResistBot() async {
    final Map<String, dynamic> resistBotData = jsonDecode(
        await Utils.getCovidActNowPage(
            "/resistbot/${widget.stateAbbr}.json")) as Map<String, dynamic>;

    final rbs = ResistBotSnapshot(
      noAction: ResistBotScenarioSnapshot(
          cumulativeAffected:
              resistBotData["noAction"]["cumulativeAffected"] as String,
          overloadedHospitals:
              resistBotData["noAction"]["overloadedHospitals"] as String,
          estimatedDeaths:
              resistBotData["noAction"]["estimatedDeaths"] as String),
      lockdown: ResistBotScenarioSnapshot(
          cumulativeAffected:
              resistBotData["lockdown"]["cumulativeAffected"] as String,
          overloadedHospitals:
              resistBotData["lockdown"]["overloadedHospitals"] as String,
          estimatedDeaths:
              resistBotData["lockdown"]["estimatedDeaths"] as String),
      shelterInPlace: ResistBotScenarioSnapshot(
          cumulativeAffected:
              resistBotData["shelterInPlace"]["cumulativeAffected"] as String,
          overloadedHospitals:
              resistBotData["shelterInPlace"]["overloadedHospitals"] as String,
          estimatedDeaths:
              resistBotData["shelterInPlace"]["estimatedDeaths"] as String),
      socialDistancing: ResistBotScenarioSnapshot(
          cumulativeAffected:
              resistBotData["socialDistancing"]["cumulativeAffected"] as String,
          overloadedHospitals: resistBotData["socialDistancing"]
              ["overloadedHospitals"] as String,
          estimatedDeaths:
              resistBotData["socialDistancing"]["estimatedDeaths"] as String),
      noReturnRangeEnd: resistBotData["noReturnRangeEnd"] as String,
      noReturnRangeStart: resistBotData["noReturnRangeStart"] as String,
      socialDistancingNoReturnRangeEnd:
          resistBotData["socialDistancingNoReturnRangeEnd"] as String,
      socialDistancingNoReturnRangeStart:
          resistBotData["socialDistancingNoReturnRangeStart"] as String,
    );

    setState(() {
      _resistBotSnapshot = rbs;
    });
  }

  DateTime _slashDateToDatetime(String slashDate) {
    final slashNums = slashDate.split("/").map((n) => int.parse(n)).toList();
    return DateTime(slashNums[2] + 2000, slashNums[0], slashNums[1]);
  }

  Future<void> _loadModels() async {
    _models = [
      await _getModelForState(stateAbbr: widget.stateAbbr, modelId: 0),
      await _getModelForState(stateAbbr: widget.stateAbbr, modelId: 1),
      await _getModelForState(stateAbbr: widget.stateAbbr, modelId: 2),
      await _getModelForState(stateAbbr: widget.stateAbbr, modelId: 3)
    ];

    _models.forEach((model) {
      var bedsAvailable = 1.0;
      ModelDaySnapshot mdsBeforeOverload;
      ModelDaySnapshot mdsAfterOverload;

      DateTime overloadDate;

      model.forEach((mds) {
        if (bedsAvailable > 0) {
          final nextBedsAvailable =
              mds.AvailableHospitalBeds - mds.PredictedHospitalized;

          bedsAvailable = nextBedsAvailable;

          if (nextBedsAvailable > 0) {
            mdsBeforeOverload = mds;
          } else {
            mdsAfterOverload = mds;
          }
        }
      });

      if (mdsAfterOverload == null || mdsBeforeOverload == null) {
        _modelOverloads.add(null);
        return;
      }

      final DateTime beforeDate = _slashDateToDatetime(mdsBeforeOverload.Date);
      final DateTime afterDate = _slashDateToDatetime(mdsAfterOverload.Date);

      final predictedHospitalizedDiff = mdsAfterOverload.PredictedHospitalized -
          mdsBeforeOverload.PredictedHospitalized;
      final daysBetweenMDSs = afterDate.difference(beforeDate).inDays;
      final phDailyStep = predictedHospitalizedDiff / daysBetweenMDSs;

      var day = 0;
      for (var predictedHospitalized = mdsBeforeOverload.PredictedHospitalized;
          predictedHospitalized <= mdsAfterOverload.PredictedHospitalized;
          predictedHospitalized += phDailyStep) {
        if (predictedHospitalized > mdsAfterOverload.AvailableHospitalBeds) {
          overloadDate = beforeDate.add(Duration(days: day - 1));
          break;
        }
        day++;
      }

      _modelOverloads.add(overloadDate);
    });

    final modelIndex =
        STATE_INTERVENTION[widget.stateAbbr] == LIMITED_ACTION ? 0 : 3;

    setState(() {
      _overloadDate = _modelOverloads[modelIndex];
      _lineData = List<charts.Series<ModelDaySnapshot, DateTime>>.from(
          Function.apply(_getStateLineData, _models) as List<dynamic>);
    });
  }

  Future<List<ModelDaySnapshot>> _getModelForState(
      {String stateAbbr, int modelId}) async {
    final stateMDSs =
        await Utils.getCovidActNowPage("/data/$stateAbbr.$modelId.json");

    final List<ModelDaySnapshot> mdss = [];
    final List<List<dynamic>> list =
        List<List<dynamic>>.from(jsonDecode(stateMDSs) as List<dynamic>);

    for (final List<dynamic> row in list) {
      final mds = ModelDaySnapshot();

      Function.apply(
          mds.load,
          row.map<dynamic>((dynamic col) {
            if (col is double) {
              return col;
            }

            if (col is String) {
              if (col.contains("/")) {
                return col;
              }
              return double.parse(col.replaceAll(",", ""));
            }

            if (col is int) {
              // SNG added return, looked like a bug
              return col.toDouble();
            }

            // SNG added return col, no return, should it be null?
            return col;
          }).toList());
      mdss.add(mds);
    }

    return mdss;
  }

  final DateFormat dateFormat = DateFormat("MMMMd");

  String _formatDateString(String formattedString) {
    DateTime date;
    try {
      date = DateTime.parse(formattedString);
    } catch (err) {
      if (formattedString == "outside time bound") {
        return "Unknown";
      }
      if (formattedString == "never") {
        return "Never";
      }
      return formattedString;
    }

    return dateFormat.format(date);
  }

  List<dynamic> _getStateLineData(
      List<ModelDaySnapshot> model0,
      List<ModelDaySnapshot> model1,
      List<ModelDaySnapshot> model2,
      List<ModelDaySnapshot> model3) {
    final intervals = [
      model0.length,
      model1.length,
      model2.length,
      model3.length
    ].reduce(math.min);

    return <dynamic>[
      charts.Series<ModelDaySnapshot, DateTime>(
          id: 'LIMITED_ACTION',
          colorFn: (_, __) =>
              _colorToChartColor(INTERVENTION_COLOR_MAP[LIMITED_ACTION]),
          areaColorFn: (_, __) =>
              _colorToChartColor(INTERVENTION_COLOR_MAP[LIMITED_ACTION])
                  .lighter,
          domainFn: (ModelDaySnapshot mds, index) =>
              _slashDateToDatetime(mds.Date),
          measureFn: (ModelDaySnapshot mds, index) => mds.PredictedHospitalized,
          data: model0.sublist(0, intervals)),
      charts.Series<ModelDaySnapshot, DateTime>(
        id: 'SHELTER_IN_PLACE',
        colorFn: (_, __) =>
            _colorToChartColor(INTERVENTION_COLOR_MAP[SHELTER_IN_PLACE]),
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (ModelDaySnapshot mds, index) =>
            _slashDateToDatetime(mds.Date),
        measureFn: (ModelDaySnapshot mds, index) => mds.PredictedHospitalized,
        data: model1.sublist(0, intervals),
      ),
      charts.Series<ModelDaySnapshot, DateTime>(
        id: 'LOCKDOWN',
        colorFn: (_, __) =>
            _colorToChartColor(INTERVENTION_COLOR_MAP[LOCKDOWN]),
        areaColorFn: (_, __) =>
            _colorToChartColor(INTERVENTION_COLOR_MAP[LOCKDOWN]),
        domainFn: (ModelDaySnapshot mds, index) =>
            _slashDateToDatetime(mds.Date),
        measureFn: (ModelDaySnapshot mds, index) => mds.PredictedHospitalized,
        data: model2.sublist(0, intervals),
      ),
      charts.Series<ModelDaySnapshot, DateTime>(
        id: 'SHELTER_IN_PLACE_WORST_CASE',
        colorFn: (_, __) => _colorToChartColor(
            INTERVENTION_COLOR_MAP[SHELTER_IN_PLACE_WORST_CASE]),
        areaColorFn: (_, __) => _colorToChartColor(
                INTERVENTION_COLOR_MAP[SHELTER_IN_PLACE_WORST_CASE])
            .lighter,
        domainFn: (ModelDaySnapshot mds, index) =>
            _slashDateToDatetime(mds.Date),
        measureFn: (ModelDaySnapshot mds, index) => mds.PredictedHospitalized,
        data: model3.sublist(0, intervals),
      ),
      charts.Series<ModelDaySnapshot, DateTime>(
        id: 'beds',
        colorFn: (_, __) => charts.MaterialPalette.black,
        dashPatternFn: (_, __) => [4, 4],
        domainFn: (ModelDaySnapshot mds, index) =>
            _slashDateToDatetime(mds.Date),
        measureFn: (ModelDaySnapshot mds, index) => mds.AvailableHospitalBeds,
        data: model0.sublist(0, intervals),
      ),
    ];
  }

  Widget _roundedIcon(
      {Widget icon,
      Color borderColor = ourDarkGrey,
      Color backgroundColor = Colors.white}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          color: borderColor, borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(100)),
          child: icon,
        ),
      ),
    );
  }

  Widget _interventionDialog({String intervention, String category}) {
    return _statusDialog(category: category, children: [
      _statusSection(
        title: INTERVENTION_TITLES[intervention],
        text: INTERVENTION_DESCRIPTIONS[intervention],
        statusIcon: _roundedIcon(
          icon: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                  color: INTERVENTION_COLOR_MAP[intervention],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      )
    ]);
  }

  charts.Color _colorToChartColor(Color color) {
    return charts.Color(r: color.red, g: color.green, b: color.blue, a: 120);
  }

  Widget _statusSection({String title, String text, Widget statusIcon}) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          statusIcon,
          Container(width: 16),
          Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: H3), Text(text)]))
        ]));
  }

  Widget _statusDialog({String category, List<Widget> children}) {
    final List<Widget> sections = [
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: ourLightGrey,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(category,
                style: H3.merge(TextStyle(fontWeight: FontWeight.bold)))),
      )
    ];

    children.forEach((final child) {
      sections.add(child);
    });

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(color: ourMediumGrey, width: 1)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: sections),
      ),
    );
  }

  Widget _scenarioCard(
      {String title,
      String infected,
      String deaths,
      String hospitalOverload,
      Color color}) {
    final lightP =
        P.merge(TextStyle(color: ourDarkGrey, fontWeight: FontWeight.normal));
    return Padding(
      padding: const EdgeInsets.only(
          top: 5, bottom: 5), //EdgeInsets.only(top: 5, right: 16, left: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 10, right: 16, bottom: 4),
                decoration: const BoxDecoration(
                    color: ourLightGrey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                    )),
                child: Text(title, style: H3)),
            Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 8),
              decoration: const BoxDecoration(
                color: ourLightGrey,
              ),
              child: DefaultTextStyle(
                style: H3.merge(
                  const TextStyle(color: Colors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [Text(deaths), Text("Deaths", style: lightP)],
                    ),
                    Column(
                      children: [
                        Text(infected),
                        Text("Infected", style: lightP)
                      ],
                    ),
                    Column(
                      children: [
                        Text(hospitalOverload),
                        Text("Hospitals Full", style: lightP)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerActNow(String state_name, String intervention) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: INTERVENTION_COLOR_MAP[intervention], width: 4))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: 'You must act now in ',
                  style: H2.merge(TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
                  children: <TextSpan>[
                    TextSpan(
                        text: state_name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: ".")
                  ],
                ),
              ),
              Container(height: 8),
              Markdown(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data:
                      """To prevent hospital overload, our projections indicate a Stay at Home order must be implemented. The sooner you act, the more lives you save."""),
            ]));
  }

  Widget _headerKeepActing(String state_name, String intervention) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: INTERVENTION_COLOR_MAP[intervention], width: 3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'Keep staying at home in ',
              style: H2.merge(TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black)),
              children: <TextSpan>[
                TextSpan(
                    text: state_name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ".")
              ],
            ),
          ),
          Container(height: 10),
          RichText(
            text: TextSpan(
              text:
                  'Avoiding hospital overload heavily depends on population density and public cooperation. Best and worst case scenarios are shown below, and we’ll update our projections as soon as more data becomes available.',
              style: P.merge(
                  TextStyle(fontWeight: FontWeight.normal, color: ourDarkGrey)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state =
        States.where((state) => state["state_code"] == widget.stateAbbr).first;
    final intervention = STATE_INTERVENTION[widget.stateAbbr];

    final List<charts.LineAnnotationSegment> rangeAnnotations = [];

    rangeAnnotations.add(charts.LineAnnotationSegment<DateTime>(
        DateTime.now(), charts.RangeAnnotationAxisType.domain,
        dashPattern: [2, 5],
        color: _colorToChartColor(Colors.black),
        startLabel: 'Today'));

    if (_overloadDate != null) {
      rangeAnnotations.add(charts.LineAnnotationSegment<dynamic>(
          _overloadDate, charts.RangeAnnotationAxisType.domain,
          color: _colorToChartColor(Colors.black),
          dashPattern: [2, 5],
          startLabel: 'Full Hospitals'));
    }

    if (_selectionDate != null) {
      rangeAnnotations.add(charts.LineAnnotationSegment<dynamic>(
        _selectionDate,
        charts.RangeAnnotationAxisType.domain,
        color: _colorToChartColor(Colors.black),
      ));
    }

    Widget overloadProjections = const Text("");
    if (_overloadDate != null) {
      if (STATE_INTERVENTION[state["state_code"]] == "shelter_in_place") {
        overloadProjections =
            _statusDialog(category: "Hospital Capacity", children: [
          _statusSection(
              title: "Poor Compliance",
              text: _modelOverloads[3] != null
                  ? "We project hospitals will become overloaded by ${dateFormat.format(_modelOverloads[3])}"
                  : "We project no overload over the next 3 months",
              statusIcon: _roundedIcon(
                  icon: Text(
                    "!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  borderColor: INTERVENTION_COLOR_MAP[intervention],
                  backgroundColor: INTERVENTION_COLOR_MAP[intervention])),
          _statusSection(
              title: "Strict Compliance",
              text: _modelOverloads[2] != null
                  ? "We project hospitals will become overloaded by ${dateFormat.format(_modelOverloads[2])}"
                  : "We project no overload over the next 3 months",
              statusIcon: _roundedIcon(
                  icon: Icon(Icons.check, size: 18, color: Colors.white),
                  borderColor: INTERVENTION_COLOR_MAP[intervention],
                  backgroundColor: INTERVENTION_COLOR_MAP[intervention]))
        ]);
      } else {
        overloadProjections =
            _statusDialog(category: "Hospital Capacity", children: [
          _statusSection(
              title: "Overload Projected",
              text:
                  "We project hospitals will become overloaded by ${dateFormat.format(_overloadDate)}",
              statusIcon: _roundedIcon(
                  icon: Text(
                    "!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  borderColor: INTERVENTION_COLOR_MAP[intervention],
                  backgroundColor: INTERVENTION_COLOR_MAP[intervention]))
        ]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(state["state"] as String),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ourLightGrey,
              border: Border(
                bottom: BorderSide(color: ourMediumGrey, width: 1),
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
              child: intervention != SHELTER_IN_PLACE
                  ? _headerActNow(state["state"] as String, intervention)
                  : _headerKeepActing(state["state"] as String, intervention),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 10),
            child: Text("Projected hospitalizations", style: H2),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: _lineData.isNotEmpty
                ? charts.TimeSeriesChart(
                    _lineData,
                    animate: false,
                    domainAxis: const charts.EndPointsTimeAxisSpec(),
                    selectionModels: [
                      charts.SelectionModelConfig(
                        type: charts.SelectionModelType.info,
                        changedListener: (column) {
                          final selectedDatum = column.selectedDatum;
                          if (selectedDatum.isNotEmpty) {
                            selectedDatum
                                .forEach((charts.SeriesDatum datumPair) {
                              setState(() {
                                final String slashDate =
                                    (datumPair.series.data[datumPair.index]
                                            as ModelDaySnapshot)
                                        .Date;
                                _selectionDate =
                                    _slashDateToDatetime(slashDate);
                                _selectionIndex = datumPair.index;
                              });
                            });
                          }
                        },
                      )
                    ],
                    behaviors: [
                      charts.RangeAnnotation(rangeAnnotations),
                    ],
                    defaultRenderer: charts.LineRendererConfig(
                      includeArea: true,
                    ),
                  )
                : Center(
                    child: Text(
                      "Loading data...",
                      style: H2.merge(
                        const TextStyle(color: ourDarkGrey),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration:
                  BoxDecoration(border: Border.all(color: ourMediumGrey)),
              child: _selectionIndex != null && _models.isNotEmpty
                  ? Markdown(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      data:
                          """## Prediction for around ${_models[0][_selectionIndex].Date}
**Limited Action** may produce **${_models[0][_selectionIndex].PredictedHospitalized} hospitializations**.
**Shelter in Place** may produce **${_models[3][_selectionIndex].PredictedHospitalized} hospitializations**.
**Stay at Home** may produce **${_models[1][_selectionIndex].PredictedHospitalized} hospitializations**.
**Lockdown** may produce **${_models[2][_selectionIndex].PredictedHospitalized} hospitializations.**""")
                  : const Text(
                      "Tap on the graph to view predictions for a date.",
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ourLightGrey,
              ),
              child: const Markdown(
                physics: NeverScrollableScrollPhysics(),
                data:
                    "This model updates **every 24 hours** and is intended to help make fast decisions, not predict the future. [Learn more about our model and its limitations.](https://docs.google.com/document/d/1ETeXAfYOvArfLvlxExE0_xrO5M4ITC0_Am38CRusCko/edit#heading=h.vyhw42b7pgoj)",
                shrinkWrap: true,
              ),
            ),
          ),
          _interventionDialog(
              category: "Current Intervention", intervention: intervention),
          overloadProjections,
          Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 10),
              child: Text("Possible Scenarios", style: H2)),
          _resistBotSnapshot != null
              ? _scenarioCard(
                  title: "Limited Action",
                  infected: _resistBotSnapshot.noAction.cumulativeAffected,
                  deaths: _resistBotSnapshot.noAction.estimatedDeaths,
                  hospitalOverload: _formatDateString(
                      _resistBotSnapshot.noAction.overloadedHospitals),
                  color: INTERVENTION_COLOR_MAP[LIMITED_ACTION])
              : const Text("..."),
          _resistBotSnapshot != null
              ? _scenarioCard(
                  title: "3 Months of Social Distancing",
                  infected:
                      _resistBotSnapshot.socialDistancing.cumulativeAffected,
                  deaths: _resistBotSnapshot.socialDistancing.estimatedDeaths,
                  hospitalOverload: _formatDateString(
                      _resistBotSnapshot.socialDistancing.overloadedHospitals),
                  color: INTERVENTION_COLOR_MAP[SOCIAL_DISTANCING])
              : const Text("..."),
          _resistBotSnapshot != null
              ? _scenarioCard(
                  title: "3 Months of Shelter in Place ●",
                  infected:
                      _resistBotSnapshot.shelterInPlace.cumulativeAffected,
                  deaths: _resistBotSnapshot.shelterInPlace.estimatedDeaths,
                  hospitalOverload: _formatDateString(
                      _resistBotSnapshot.shelterInPlace.overloadedHospitals),
                  color: INTERVENTION_COLOR_MAP[SHELTER_IN_PLACE])
              : const Text("..."),
          _resistBotSnapshot != null
              ? _scenarioCard(
                  title: "3 Months of Lockdown ●●",
                  infected: _resistBotSnapshot.lockdown.cumulativeAffected,
                  deaths: _resistBotSnapshot.lockdown.estimatedDeaths,
                  hospitalOverload: _formatDateString(
                      _resistBotSnapshot.lockdown.overloadedHospitals),
                  color: INTERVENTION_COLOR_MAP[LOCKDOWN])
              : const Text("..."),
          Markdown(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            data:
                """● **A second spike in disease may occur after social distancing is stopped.** Interventions are important because they buy time to create surge capacity in hospitals and develop therapeutic drugs that may have potential to lower hospitalization and fatality rates from COVID. [See full scenario definitions here](https://data.covidactnow.org/Covid_Act_Now_Model_References_and_Assumptions.pdf).
          
●● **Our models show that it would take at least 2 months of Wuhan-style Lockdown to achieve full containment.** However, it is unclear at this time how you could manage newly introduced infections. [See full scenario definitions here](https://data.covidactnow.org/Covid_Act_Now_Model_References_and_Assumptions.pdf).
          """,
            onTapLink: (url) {
              launch(url);
            },
          ),
          Container(height: 16)
        ],
      ),
    );
  }
}
