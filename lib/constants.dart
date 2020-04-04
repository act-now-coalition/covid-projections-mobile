import 'package:flutter/material.dart';

const ourLightGrey = Color.fromRGBO(0, 0, 0, 0.05);
const ourMediumGrey = Color.fromRGBO(0, 0, 0, 0.1);
const ourDarkGrey = Color.fromRGBO(0, 0, 0, 0.7);
const ourHighlight = Color.fromRGBO(7, 209, 128, 1);

const H1 = TextStyle(fontSize: 30, fontWeight: FontWeight.normal);
const H2 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const H3 =
    TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);
const P = TextStyle(fontSize: 14, color: ourDarkGrey);

const States = [
  {
    "state_code": "AK",
    "state": "Alaska",
    "state_fips_code": "02",
    "population": 731545
  },
  {
    "state_code": "AL",
    "state": "Alabama",
    "state_fips_code": "01",
    "population": 4903185
  },
  {
    "state_code": "AR",
    "state": "Arkansas",
    "state_fips_code": "05",
    "population": 3017825
  },
  {
    "state_code": "AZ",
    "state": "Arizona",
    "state_fips_code": "04",
    "population": 7278717
  },
  {
    "state_code": "CA",
    "state": "California",
    "state_fips_code": "06",
    "population": 39512223
  },
  {
    "state_code": "CO",
    "state": "Colorado",
    "state_fips_code": "08",
    "population": 5758736
  },
  {
    "state_code": "CT",
    "state": "Connecticut",
    "state_fips_code": "09",
    "population": 3565287
  },
// TODO: Figure out what to do with DC
//  {
//    "state_code": "DC",
//    "state": "District of Columbia",
//    "state_fips_code": "11",
//    "population": 705749
//  },
  {
    "state_code": "DE",
    "state": "Delaware",
    "state_fips_code": "10",
    "population": 973764
  },
  {
    "state_code": "FL",
    "state": "Florida",
    "state_fips_code": "12",
    "population": 21477737
  },
  {
    "state_code": "GA",
    "state": "Georgia",
    "state_fips_code": "13",
    "population": 10617423
  },
  {
    "state_code": "HI",
    "state": "Hawaii",
    "state_fips_code": "15",
    "population": 1415872
  },
  {
    "state_code": "IA",
    "state": "Iowa",
    "state_fips_code": "19",
    "population": 3155070
  },
  {
    "state_code": "ID",
    "state": "Idaho",
    "state_fips_code": "16",
    "population": 1787147
  },
  {
    "state_code": "IL",
    "state": "Illinois",
    "state_fips_code": "17",
    "population": 12671821
  },
  {
    "state_code": "IN",
    "state": "Indiana",
    "state_fips_code": "18",
    "population": 6732219
  },
  {
    "state_code": "KS",
    "state": "Kansas",
    "state_fips_code": "20",
    "population": 2913314
  },
  {
    "state_code": "KY",
    "state": "Kentucky",
    "state_fips_code": "21",
    "population": 4467673
  },
  {
    "state_code": "LA",
    "state": "Louisiana",
    "state_fips_code": "22",
    "population": 4648794
  },
  {
    "state_code": "MA",
    "state": "Massachusetts",
    "state_fips_code": "25",
    "population": 6949503
  },
  {
    "state_code": "MD",
    "state": "Maryland",
    "state_fips_code": "24",
    "population": 6045680
  },
  {
    "state_code": "ME",
    "state": "Maine",
    "state_fips_code": "23",
    "population": 1344212
  },
  {
    "state_code": "MI",
    "state": "Michigan",
    "state_fips_code": "26",
    "population": 9986857
  },
  {
    "state_code": "MN",
    "state": "Minnesota",
    "state_fips_code": "27",
    "population": 5639632
  },
  {
    "state_code": "MO",
    "state": "Missouri",
    "state_fips_code": "29",
    "population": 6137428
  },
  {
    "state_code": "MS",
    "state": "Mississippi",
    "state_fips_code": "28",
    "population": 2976149
  },
  {
    "state_code": "MT",
    "state": "Montana",
    "state_fips_code": "30",
    "population": 1068778
  },
  {
    "state_code": "NC",
    "state": "North Carolina",
    "state_fips_code": "37",
    "population": 10488084
  },
  {
    "state_code": "ND",
    "state": "North Dakota",
    "state_fips_code": "38",
    "population": 762062
  },
  {
    "state_code": "NE",
    "state": "Nebraska",
    "state_fips_code": "31",
    "population": 1934408
  },
  {
    "state_code": "NH",
    "state": "New Hampshire",
    "state_fips_code": "33",
    "population": 1359711
  },
  {
    "state_code": "NJ",
    "state": "New Jersey",
    "state_fips_code": "34",
    "population": 8882190
  },
  {
    "state_code": "NM",
    "state": "New Mexico",
    "state_fips_code": "35",
    "population": 2096829
  },
  {
    "state_code": "NV",
    "state": "Nevada",
    "state_fips_code": "32",
    "population": 3080156
  },
  {
    "state_code": "NY",
    "state": "New York",
    "state_fips_code": "36",
    "population": 19453561
  },
  {
    "state_code": "OH",
    "state": "Ohio",
    "state_fips_code": "39",
    "population": 11689100
  },
  {
    "state_code": "OK",
    "state": "Oklahoma",
    "state_fips_code": "40",
    "population": 3956971
  },
  {
    "state_code": "OR",
    "state": "Oregon",
    "state_fips_code": "41",
    "population": 4217737
  },
  {
    "state_code": "PA",
    "state": "Pennsylvania",
    "state_fips_code": "42",
    "population": 12801989
  },
  {
    "state_code": "RI",
    "state": "Rhode Island",
    "state_fips_code": "44",
    "population": 1059361
  },
  {
    "state_code": "SC",
    "state": "South Carolina",
    "state_fips_code": "45",
    "population": 5148714
  },
  {
    "state_code": "SD",
    "state": "South Dakota",
    "state_fips_code": "46",
    "population": 884659
  },
  {
    "state_code": "TN",
    "state": "Tennessee",
    "state_fips_code": "47",
    "population": 6833174
  },
  {
    "state_code": "TX",
    "state": "Texas",
    "state_fips_code": "48",
    "population": 28995881
  },
  {
    "state_code": "UT",
    "state": "Utah",
    "state_fips_code": "49",
    "population": 3205958
  },
  {
    "state_code": "VA",
    "state": "Virginia",
    "state_fips_code": "51",
    "population": 8535519
  },
  {
    "state_code": "VT",
    "state": "Vermont",
    "state_fips_code": "50",
    "population": 623989
  },
  {
    "state_code": "WA",
    "state": "Washington",
    "state_fips_code": "53",
    "population": 7614893
  },
  {
    "state_code": "WI",
    "state": "Wisconsin",
    "state_fips_code": "55",
    "population": 5822434
  },
  {
    "state_code": "WV",
    "state": "West Virginia",
    "state_fips_code": "54",
    "population": 1792065
  },
  {
    "state_code": "WY",
    "state": "Wyoming",
    "state_fips_code": "56",
    "population": 578759
  }
];

const LIMITED_ACTION = "limited_action";
const SOCIAL_DISTANCING = "social_distancing";
const SHELTER_IN_PLACE = "shelter_in_place";
const SHELTER_IN_PLACE_WORST_CASE = "shelter_in_place_worse_cast";
const LOCKDOWN = "lockdown";

const INTERVENTION_DESCRIPTIONS = {
  LIMITED_ACTION:
      'Public advocacy around “social distancing” and enhanced hygiene. Minimal mandated restrictions.',
  SOCIAL_DISTANCING:
      'Voluntary “stay at home” directive for high-risk groups, schools and bars / restaurants closed.',
  SHELTER_IN_PLACE:
      'Legal order for citizens to employ “stay at home” quarantine except for essential activities, shutdown of non-essential businesses, ban on all group events.',
};

const INTERVENTION_COLOR_MAP = {
  LIMITED_ACTION: Color.fromRGBO(255, 51, 72, 1), // red
  SOCIAL_DISTANCING: Color.fromRGBO(255, 144, 0, 1), // orange
  SHELTER_IN_PLACE: Color.fromRGBO(30, 224, 175, 1), // green
  SHELTER_IN_PLACE_WORST_CASE: Color.fromRGBO(18, 146, 116, 1), // green
  LOCKDOWN: Color.fromRGBO(223, 31, 210, 1), // purple
};

const INTERVENTION_TITLES = {
  null: "Not Reported",
  SHELTER_IN_PLACE: "Shelter in Place",
  SOCIAL_DISTANCING: "Social Distancing",
  LIMITED_ACTION: "Limited Action"
};

//TODO: Figure out how to pull this
const STATE_INTERVENTION = {
  "AK": "shelter_in_place",
  "AL": "social_distancing",
  "AZ": "shelter_in_place",
  "AR": "social_distancing",
  "CA": "shelter_in_place",
  "CO": "shelter_in_place",
  "CT": "shelter_in_place",
  "DE": "shelter_in_place",
  "FL": "shelter_in_place",
  "GA": "shelter_in_place",
  "HI": "shelter_in_place",
  "ID": "shelter_in_place",
  "IL": "shelter_in_place",
  "IN": "shelter_in_place",
  "IA": "social_distancing",
  "KS": "shelter_in_place",
  "KY": "shelter_in_place",
  "LA": "shelter_in_place",
  "ME": "shelter_in_place",
  "MD": "shelter_in_place",
  "MA": "shelter_in_place",
  "MI": "shelter_in_place",
  "MN": "shelter_in_place",
  "MS": "shelter_in_place",
  "MO": "social_distancing",
  "MT": "shelter_in_place",
  "NE": "social_distancing",
  "NV": "shelter_in_place",
  "NH": "shelter_in_place",
  "NJ": "shelter_in_place",
  "NM": "shelter_in_place",
  "NY": "shelter_in_place",
  "NC": "shelter_in_place",
  "ND": "social_distancing",
  "OH": "shelter_in_place",
  "OK": "social_distancing",
  "OR": "shelter_in_place",
  "PA": "shelter_in_place",
  "RI": "shelter_in_place",
  "SC": "social_distancing",
  "SD": "limited_action",
  "TN": "shelter_in_place",
  "TX": "social_distancing",
  "UT": "social_distancing",
  "VT": "shelter_in_place",
  "VA": "shelter_in_place",
  "WA": "shelter_in_place",
  "WV": "shelter_in_place",
  "WI": "shelter_in_place",
  "WY": "social_distancing"
};
