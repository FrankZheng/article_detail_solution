import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

import 'model.dart';

class ArticleContentAnalyzer {
  void _parseHtmlTags(dom.Element e, Map<String, int> tags) {
    var key = e.localName;
    if (tags.containsKey(key)) {
      tags[key] += 1;
    } else {
      tags[key] = 1;
    }
    e.children.forEach((child) {
      _parseHtmlTags(child, tags);
    });
  }

  //merge map1 to map2
  void _mergeTags(Map<String, int> map1, Map<String, int> map2) {
    for (var key in map1.keys) {
      if (map2.containsKey(key)) {
        map2[key] += 1;
      } else {
        map2[key] = 1;
      }
    }
  }

  Future<void> analyzeHtmlTags() async {
    Map<String, int> allTags = {};
    for (int page = 1; page < 30; page++) {
      List<Article> articles = await Model.shared.fetchArticles(page);
      for (Article article in articles) {
        if (article.id == null || article.id.isEmpty) {
          continue;
        }

        Article a = await Model.shared.loadArticle(article.id);
        if (a.content == null || a.content.isEmpty) {
          print('${article.id} no content');
          continue;
        }
        try {
          var doc = parse(a.content);
          Map<String, int> tags = {};
          doc.body.children.forEach((child) {
            _parseHtmlTags(child, tags);
          });
          print('${article.id}, $tags');
          _mergeTags(tags, allTags);
        } catch (e) {
          print('parse failed, $e');
          continue;
        }
      }
    }
    List<String> keys = allTags.keys.toList();
    keys.sort();
    for (var key in keys) {
      print('$key: ${allTags[key]}');
    }
  }
}
