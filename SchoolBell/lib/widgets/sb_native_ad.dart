import 'package:google_mobile_ads/google_mobile_ads.dart';

class SbNativeAd {
  static const _adUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const _factoryId = 'sbNativeAdFactory';

  static final NativeAd _customNativeAd = NativeAd(
    // TODO: replace adUnitId from sample to release version
    adUnitId: _adUnitId,
    factoryId: _factoryId,
    request: const AdRequest(),
    listener: NativeAdListener(),
  );

  static NativeAd get customNativeAd => _customNativeAd;
}
