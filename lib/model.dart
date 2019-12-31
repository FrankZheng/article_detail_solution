import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';

class Article {
  final String id;
  final String html5;
  final String content;
  final String thumbnail;
  final String title;
  final String excerpt;
  final String lead;
  final String author;
  final String updateTime;

  Article(
      {this.id,
      this.html5,
      this.content,
      this.thumbnail,
      this.title,
      this.excerpt,
      this.lead,
      this.author,
      this.updateTime});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'].toString(),
        html5: json['html5'].toString(),
        content: json['content'].toString(),
        thumbnail: json['thumbnail'].toString(),
        title: json['title'].toString(),
        excerpt: json['excerpt'].toString(),
        lead: json['lead'].toString(),
        author: json['author'].toString(),
        updateTime: json['update_time'].toString());
  }
}

class Model {
  static Model shared = Model();
  Map<String, Article> articles = {};

  final Dio _dio = Dio();

  Model() {
    _dio.options.baseUrl = 'http://static.owspace.com';
  }

  Future<Article> loadArticle(String id) async {
    if (articles.containsKey(id)) {
      return articles[id];
    }

    //http://static.owspace.com/?c=api&a=getPost&post_id=296471&show_sdv=1
    try {
      var response = await _dio.get("/", queryParameters: {
        "c": "api",
        "a": "getPost",
        "post_id": id,
        "show_sdv": 1
      });
      Article article = Article.fromJson(response.data['datas']);
      articles[id] = article;
      return article;
    } on DioError catch (e) {
      print('Failed to load article, $id, ${e.toString()}');
    }
    return null;
  }
}
