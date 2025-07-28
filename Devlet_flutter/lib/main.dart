import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewWithTabs(),
    );
  }
}


class WebViewWithTabs extends StatefulWidget {
  const WebViewWithTabs({super.key});

  @override
  State<WebViewWithTabs> createState() => _WebViewWithTabsState();
}

class _WebViewWithTabsState extends State<WebViewWithTabs> {
  int _currentIndex = 0;
  late InAppWebViewController _webViewController;

  final _tabs = [
    'https://github.com/isGeekCode/TIL/blob/main/Mobile_03_Flutter/00.Devlet_Flutter.md',
    'https://example.com/settings' // This is a placeholder, adjust as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentIndex == 0 ? 'Devlet: Flutter' : '설정')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(_tabs[_currentIndex]),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final uri = navigationAction.request.url;
          if (uri != null && uri.scheme == 'app') {
            if (uri.host == 'home') {
              setState(() {
                _currentIndex = 0;
              });
              _webViewController.loadUrl(
                urlRequest: URLRequest(url: WebUri(_tabs[0])),
              );
            } else if (uri.host == 'settings') {
              setState(() {
                _currentIndex = 1;
              });
              _webViewController.loadUrl(
                urlRequest: URLRequest(url: WebUri(_tabs[1])),
              );
            }
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _webViewController.loadUrl(
              urlRequest: URLRequest(url: WebUri(_tabs[index])),
            );
          });
        },
      ),
    );
  }
}