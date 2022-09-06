import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_admob/model/news_model.dart';
import 'package:flutter_google_admob/src/news/news_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';

class NewsApp extends StatefulWidget {
  final List<Article> newsArtData;
  const NewsApp({
    Key? key,
    required this.newsArtData,
  }) : super(key: key);

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<NewsProvider>(context);

    return ListView.builder(
        itemCount: widget.newsArtData.length,
        itemBuilder: (ctx, idx) {
          DateTime pdate = widget.newsArtData[idx].publishedAt;
          return Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.3,
                child: CachedNetworkImage(
                  imageUrl: widget.newsArtData[idx].urlToImage!,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      LottieBuilder.asset('assets/lotties/no_image.json'),
                ),
              ),
              InkWell(
                onTap: () {
                  _provider.showInterstitialAd();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetails(
                        newsImageUrl:
                            widget.newsArtData[idx].urlToImage ?? 'null',
                        newsTitle: widget.newsArtData[idx].title ?? '',
                        newsName: widget.newsArtData[idx].source.name,
                        newsDesc: widget.newsArtData[idx].description ?? '',
                        publishAt: widget.newsArtData[idx].publishedAt,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        widget.newsArtData[idx].title!,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                        ),
                        maxLines: 4,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 60,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.newsArtData[idx].source.name,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${pdate.day}/${pdate.month}/${pdate.year}',
                          style: GoogleFonts.gabriela(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
