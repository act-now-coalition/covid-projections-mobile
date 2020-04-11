import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<Uri> createDynamicLink(String stateAbbr) async {
  const String uriPrefix = 'https://covidactnow.page.link';
  final String link = 'https://covidactnow.org/mobile?state=$stateAbbr';
  const String androidPackageName = 'org.covidactnow.mobile';
  const String iosBundleId = 'org.covidactnow.mobile';
  const String appStoreId = '1507057049';
  const String title = 'Act now. Save lives.';
  const String description =
      'Understand when hospitals will likely become overloaded by COVID and what you can do to stop it.';
  final Uri imageUrl =
      Uri.parse('https://covidactnow.org/static/media/can_logo.0ac0983b.png');

  final DynamicLinkParameters components = DynamicLinkParameters(
    uriPrefix: uriPrefix,
    link: Uri.parse(link),
    androidParameters: AndroidParameters(
      packageName: androidPackageName,
    ),
    iosParameters: IosParameters(
      bundleId: iosBundleId,
      appStoreId: appStoreId,
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: title,
      description: description,
      imageUrl: imageUrl,
    ),
  );

  final ShortDynamicLink shortDynamicLink = await components.buildShortLink();

  return shortDynamicLink.shortUrl;
}
