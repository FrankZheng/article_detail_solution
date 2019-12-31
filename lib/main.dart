import 'package:flutter/material.dart';

import 'flutter_html_widget.dart';
import 'webview_flutter_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String articleId = '296529';
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('webview_flutter html5 link'),
            onTap: () {
              pushToWiget(WebViewFlutterWidget(articleId));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('webview_flutter static content'),
            onTap: () {
              pushToWiget(WebViewFlutterWidget(articleId, true));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('flutter_webview_plugin html5 link'),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('flutter_webview_plugin static content'),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
              title: Text('flutter_html static content'),
              onTap: () {
                pushToWiget(FlutterHtmlWidget(articleId));
              }),
          Divider(
            color: Colors.grey,
          ),
        ],
      )),
    );
  }

  void pushToWiget(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
