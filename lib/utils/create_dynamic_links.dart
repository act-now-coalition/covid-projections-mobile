import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<Uri> createDynamicLink(String stateAbbr) async {
  // https://covidactnow.page.link/?link=https://covidactnow.org/&isi=1507057049&ibi=org.covidactnow.mobile

  final DynamicLinkParameters components = DynamicLinkParameters(
    uriPrefix: 'https://covidactnow.page.link',
    link: Uri.parse('https://covidactnow.org/open?state=$stateAbbr'),
    androidParameters: AndroidParameters(
      packageName: 'org.covidactnow.mobile',
      //   minimumVersion: 125,
    ),
    iosParameters: IosParameters(
      bundleId: 'org.covidactnow.mobile',
      // minimumVersion: '1.0.1',
      appStoreId: '1507057049',
    ),
    // googleAnalyticsParameters: GoogleAnalyticsParameters(
    //   campaign: 'example-promo',
    //   medium: 'social',
    //   source: 'orkut',
    // ),
    // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    //   providerToken: '123456',
    //   campaignToken: 'example-promo',
    // ),
    // socialMetaTagParameters: SocialMetaTagParameters(
    //   title: 'Example of a Dynamic Link',
    //   description: 'This link works whether app is installed or not!',
    // ),
  );

  final ShortDynamicLink shortDynamicLink = await components.buildShortLink();

  return shortDynamicLink.shortUrl;
}
