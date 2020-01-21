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
        //print(e.localName);
        Widget p = _parseParagraph(e);
        if (p != null) {
          widgets.add(p);
        }
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F7F5),
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: ListView(
          // physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: widgets,
        ),
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
        if (width != null && height != null) {
          double scaleWidth = MediaQuery.of(context).size.width - 15 * 2;
          double scaleHeight = scaleWidth * height / width;
          return Container(
            width: scaleWidth,
            height: scaleHeight,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 19),
            child: Image.network(src),
          );
        }
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

  List<TextSpan> _parseTextParagraph(dom.Node node, bool indent) {
    //debugPrint('${node.nodeType}');
    List<TextSpan> spans = [];
    for (dom.Node child in node.nodes) {
      if (child.nodeType == dom.Node.TEXT_NODE) {
        debugPrint('text:${node.text}');
        String prefix = indent ? '        ' : "";
        if (indent) {
          indent = false;
        }
        spans.add(new TextSpan(text: '$prefix${child.text}'));
      } else if (child.nodeType == dom.Node.ELEMENT_NODE) {
        dom.Element element = child;
        debugPrint('element: ${element.localName}');
        if (element.localName == 'strong') {
          spans.add(new TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold),
              children: _parseTextParagraph(child, indent)));
        } else if (element.localName == 'span') {
          spans.add(new TextSpan(
              style: TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
              children: _parseTextParagraph(child, indent)));
        } else if (element.localName == 'br') {
          spans.add(new TextSpan(text: '\n'));
        }
      }
    }
    return spans;
  }

  Widget _parseParagraph(dom.Element e) {
    if (e.localName == 'p') {
      //check if has image
      Widget img = _getImage(e);
      if (img != null) {
        return img;
      }
      return Container(
        padding: const EdgeInsets.only(bottom: 19),
        child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: TextStyle(
                    height: 1.8,
                    color: Color(0xFF1C1C1C),
                    fontWeight: FontWeight.w300,
                    fontSize: 16),
                children: _parseTextParagraph(e, true))),
      );
    } else if (e.localName == 'h5') {
      return Container(
        child: Text(
          e.text,
          style: TextStyle(color: Colors.red, fontSize: 13, letterSpacing: 2),
        ),
        margin: EdgeInsets.only(bottom: 23),
      );
    } else if (e.localName == 'h2') {
      return Container(
        child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              children: _parseTextParagraph(e, false),
              style: TextStyle(
                  color: Color(0xFF1C1C1C),
                  fontSize: 18,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
            )),
        margin: EdgeInsets.only(top: 35, bottom: 20),
      );
    }
    return null;
  }
}
