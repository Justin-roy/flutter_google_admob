import 'dart:convert';

NewsData newsDataFromJson(String str) => NewsData.fromJson(json.decode(str));
String newsDataToJson(NewsData data) => json.encode(data.toJson());

class NewsData {
  NewsData({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Source source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime publishedAt;
  String content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"] ?? 'null',
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"] ?? 'null',
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] ?? 'null',
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author ?? 'null',
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage ?? 'null',
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  Source({
    required this.id,
    required this.name,
  });

  String? id;
  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] ?? 'null',
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 'null',
        "name": name,
      };
}
