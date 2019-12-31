import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import 'model.dart';

class FlutterHtmlWidget extends StatefulWidget {
  final String articleId;

  FlutterHtmlWidget(this.articleId);

  @override
  _FlutterHtmlWidgetState createState() => _FlutterHtmlWidgetState();
}

class _FlutterHtmlWidgetState extends State<FlutterHtmlWidget> {
  Article _article;

  Future<void> _init() async {
    final article = await Model.shared.loadArticle(widget.articleId);
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
        body: _article == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '12月28日下午的杭州，历经世界、失语、时间、创造、困境五个主题叙事，第五届单向街书店文学奖的9部年度作品和7个年度作者大奖全部揭晓。今天我们公布这份获奖名单和所有获奖者的发言，作为2019年的年终总结，也开启新的一年。',
                        textAlign: TextAlign.justify,
                        //style: TextStyle(fontFamily: "PMingLiU"),
                      ),
                    ),
                    Html(
                      useRichText: false,
                      padding: EdgeInsets.all(8.0),
                      data: _article.content,
                      customTextAlign: (dom.Node node) {
                        if (node is dom.Element) {
                          print(node.localName);
                          switch (node.localName) {
                            case "p":
                              return TextAlign.justify;
                          }
                        }
                        return null;
                      },
                      defaultTextStyle: TextStyle(fontSize: 18, height: 2),
                    ),
                  ],
                ),
              ));
  }
}
