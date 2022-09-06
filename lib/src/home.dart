import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_admob/model/news_model.dart';
import 'package:flutter_google_admob/src/news/news.dart';
import 'package:flutter_google_admob/src/provider/news_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<NewsProvider>(context);
    _provider.createBannerAd();
    _provider.createInterstitialAd();
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: LottieBuilder.asset('assets/lotties/avatar.json'),
        title: Text(
          'Flutter Admob',
          style: GoogleFonts.gabriela(),
        ),
      ),
      body: FutureBuilder<List<Article>>(
          future: _fetchNewsData(
              country: 'in',
              apiKey: 'c9b102f81e254f15b3b490a1121d4903',
              newsProvider: _provider),
          builder: (ctx, snap) {
            if (snap.hasData) {
              return NewsApp(newsArtData: _provider.newsModelData);
            } else if (snap.hasError) {
              return Center(child: Text("${snap.error}"));
            } else if (snap.data?.length == 0) {
              return Center(child: Text("No Data"));
            }

            return Center(
              child: LottieBuilder.asset('assets/lotties/loading_2.json'),
            );
          }),
      bottomNavigationBar: _provider.isBannerAdLoaded
          ? SizedBox(
              height: _provider.bannerAd.size.height.toDouble(),
              width: _provider.bannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: _provider.bannerAd,
              ),
            )
          : null,
    );
  }

  Future<List<Article>> _fetchNewsData({
    required String country,
    required String apiKey,
    required NewsProvider newsProvider,
  }) async {
    try {
      var apiUrl =
          "https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey";
      var response = await http.get(Uri.parse(apiUrl));
      print(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var data = NewsData.fromJson(json);

        newsProvider.newModelData = data.articles;
        newsProvider.isLoading = false;

        print(response.body);
      } else {
        newsProvider.isLoading = true;

        Toast.show("${response.reasonPhrase}: ${response.statusCode}",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } catch (e) {
      newsProvider.isLoading = true;

      Toast.show("$e", duration: Toast.lengthShort, gravity: Toast.bottom);
    }

    return [];
  }
}
