import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model.dart';

class WebViewFlutterWidget extends StatefulWidget {
  final String articleId;
  final bool useStatic;
  WebViewFlutterWidget(this.articleId, [this.useStatic = false]);

  @override
  _WebViewFlutterWidgetState createState() => _WebViewFlutterWidgetState();
}

class _WebViewFlutterWidgetState extends State<WebViewFlutterWidget> {
  Article _article;
  String _content;

  Future<void> _init() async {
    final article = await Model.shared.loadArticle(widget.articleId);
    String html = await rootBundle.loadString('assets/article_detail.html');
    _content = sprintf(html, [
      article.thumbnail,
      article.updateTime,
      article.title,
      article.author,
      article.lead,
      article.content,
    ]);
    setState(() {
      _article = article;
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _article == null
            ? Center(child: CircularProgressIndicator())
            : buildWebView());
  }

  Widget buildWebView() {
    String url = widget.useStatic
        ? Uri.dataFromString(_content,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString()
        : _article.html5;
    return Padding(
      padding: EdgeInsets.zero,
      child: WebView(
        initialUrl: url,
      ),
    );
  }
}
