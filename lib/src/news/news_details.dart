import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class NewsDetails extends StatelessWidget {
  final String newsImageUrl, newsTitle, newsDesc, newsName;
  final DateTime publishAt;

  const NewsDetails({
    Key? key,
    required this.newsImageUrl,
    required this.newsTitle,
    required this.newsDesc,
    required this.newsName,
    required this.publishAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy - kk:mm').format(publishAt);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newsName,
          style: GoogleFonts.gabriela(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  formattedDate,
                  style: GoogleFonts.gabriela(),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width,
                child: newsImageUrl == 'null'
                    ? LottieBuilder.asset('assets/lotties/no_image.json')
                    : CachedNetworkImage(
                        imageUrl: newsImageUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
              //Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  newsTitle,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                  ),
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              //Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  newsDesc,
                  style: GoogleFonts.roboto(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
