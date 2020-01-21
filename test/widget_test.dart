// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:article_detail_solution/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:article_detail_solution/main.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await analyzeArticleContentTags();
  });
}

void _testWidgets() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

void test() {}

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

Future<void> analyzeArticleContentTags() async {
  Map<String, int> allTags = {};
  for (int page = 1; page < 2; page++) {
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
      var doc = parse(a.content);
      Map<String, int> tags = {};
      doc.body.children.forEach((child) {
        _parseHtmlTags(child, tags);
      });
      print('${article.id}, $tags');
      allTags.addAll(tags);
    }
  }
}
