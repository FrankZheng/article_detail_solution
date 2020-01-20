import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

import 'model.dart';

class FlutterHtmlParseView extends StatefulWidget {
  final String articleId;
  FlutterHtmlParseView({@required this.articleId});

  @override
  _FlutterHtmlParseViewState createState() => _FlutterHtmlParseViewState();
}

class _FlutterHtmlParseViewState extends State<FlutterHtmlParseView> {
  Article _article;
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (_article != null) {
      var doc = parse(_article.content);
      doc.body.children.forEach((e) {
        print(e.localName);
        Widget p = _parseParagraph(e);
        if (p != null) {
          widgets.add(p);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: widgets,
      ),
    );
  }

  Future<void> _init() async {
    final article = await Model.shared.loadArticle(widget.articleId);
    setState(() {
      _article = article;
    });
  }

  Widget _getImage(dom.Element element) {
    for (dom.Element e in element.children) {
      if (e.localName == 'img') {
        var attr = e.attributes;
        String src = attr['src'];
        double width = double.parse(attr['width']);
        double height = double.parse(attr['height']);
        debugPrint('$src, $width, $height');
        return Image.network(src);
      } else {
        var img = _getImage(e);
        if (img != null) {
          return img;
        }
      }
    }
    return null;
  }

  Widget _parseParagraph(dom.Element e) {
    if (e.localName == 'p') {
      //check if has image
      Widget img = _getImage(e);
      if (img != null) {
        return img;
      }
    } else if (e.localName == 'h2' || e.localName == 'h5') {}
    return null;
  }
}
