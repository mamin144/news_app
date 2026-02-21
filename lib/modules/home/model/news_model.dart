/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
    NewsModel({
        required this.totalResults,
        required this.articles,
        required this.status,
      this.code,
      this.message,
    });

    int totalResults;
    List<News> articles;
    String status;
    String? message;
    String? code;


    factory NewsModel.fromJson(Map<dynamic, dynamic> json) => NewsModel(
        totalResults: json["totalResults"],
        articles: List<News>.from(json["articles"].map((x) => News.fromJson(x))),
        status: json["status"],
      message: json["message"],
      code: json["code"],

    );

    Map<dynamic, dynamic> toJson() => {
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
        "status": status,
    };
}

class News {
    News({
        required this.publishedAt,
        this.author,
        required this.urlToImage,
        required this.description,
        required this.source,
        required this.title,
        required this.url,
        required this.content,
    });

    DateTime publishedAt;
    String? author;
    String urlToImage;
    String description;
    Source source;
    String title;
    String url;
    String content;

    factory News.fromJson(Map<dynamic, dynamic> json) => News(
        publishedAt: DateTime.parse(json["publishedAt"]),
        author: json["author"],
        urlToImage: json["urlToImage"],
        description: json["description"],
        source: Source.fromJson(json["source"]),
        title: json["title"],
        url: json["url"],
        content: json["content"],
    );

    Map<dynamic, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "author": author,
        "urlToImage": urlToImage,
        "description": description,
        "source": source.toJson(),
        "title": title,
        "url": url,
        "content": content,
    };
}

class Source {
    Source({
        required this.name,
        this.id,
    });

    String name;
    String? id;

    factory Source.fromJson(Map<dynamic, dynamic> json) => Source(
        name: json["name"],
        id: json["id"],
    );

    Map<dynamic, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
