import 'package:flutter/material.dart';
import 'package:flutter_google_admob/model/news_model.dart';
import 'package:flutter_google_admob/src/news_admob/news_admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NewsProvider extends ChangeNotifier {
  int _maxFailedLoadAttempts = 3;
  int _interstitialAdLoadAttempt = 0;
  NewsAdMob _newsAdMob = NewsAdMob();
  bool _isLoading = true;
  List<Article> _newsModelData = [];

  late BannerAd _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdLoaded = false;

  // getters
  List<Article> get newsModelData => _newsModelData;
  BannerAd get bannerAd => _bannerAd;
  InterstitialAd get interstitialAd => _interstitialAd!;
  bool get isLoading => _isLoading;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  //setters
  set newModelData(value) {
    _newsModelData = value;
    notifyListeners();
  }

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  // Functions
  void createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _newsAdMob.bannerTestUnitID,
      listener: BannerAdListener(onAdLoaded: (_) {
        _isBannerAdLoaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, err) {
        ad.dispose();
      }),
      request: const AdRequest(),
    );
    _bannerAd.load();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _newsAdMob.interstitialTestUnitID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAdLoadAttempt = 0;
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError err) {
          _interstitialAdLoadAttempt += 1;
          _interstitialAd = null;
          if (_interstitialAdLoadAttempt >= _maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError er) {
        ad.dispose();
        createInterstitialAd();
      });
      _interstitialAd!.show();
    }
  }
}
