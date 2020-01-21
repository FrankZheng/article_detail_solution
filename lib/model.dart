import 'dart:io';

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
        id: json['id'],
        html5: json['html5'].toString(),
        content: json['content'],
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
    _dio.options.connectTimeout = 3000;
    _dio.options.receiveTimeout = 3000;
  }

  Future<List<Article>> fetchArticles(int page) async {
    List<Article> articles = [];
    try {
      Response response = await _dio.get("/", queryParameters: {
        "c": "api",
        "a": "getList",
        "p": "$page",
        "model": 0,
        "create_time": 0,
        "client": Platform.isAndroid ? "android" : "iOS",
        "version": "1.3.0",
        "time": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "device_id":
            "866963027059338", //figure out the random number logic later
        "show_sdv": 1
      });

      for (Map<String, dynamic> m in response.data['datas']) {
        Article article = Article.fromJson(m);
        articles.add(article);
      }
    } on DioError catch (e) {
      print('Failded to fetch articles, $e');
    }
    return articles;
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
