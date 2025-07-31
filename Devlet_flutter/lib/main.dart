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
      body: _currentIndex == 0
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_tabs[_currentIndex]),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                if (uri != null) {
                  if (uri.scheme == 'app') {
                    if (uri.host == 'home') {
                      setState(() {
                        _currentIndex = 0;
                      });
                      _webViewController.loadUrl(
                        urlRequest: URLRequest(url: WebUri(_tabs[0])),
                      );
                    }
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
            )
          : const SettingsPage(),
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
            if (_currentIndex == 0) {
              _webViewController.loadUrl(
                urlRequest: URLRequest(url: WebUri(_tabs[0])),
              );
            }
            // No need to load URL for settings; handled by native widget.
          });
        },
      ),
    );
  }

  void _openSubWebView(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("SubView")),
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(url),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('여기는 네이티브 설정 페이지입니다'),
      ),
    );
  }
}