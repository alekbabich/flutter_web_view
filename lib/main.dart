import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: WebView(
            initialUrl: 'https://www.litterpic.com/',
            onWebViewCreated: (controller) => _controller.complete(controller),
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
          bottomNavigationBar: Container(
            color: Color.fromARGB(255, 160, 210, 166),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 110),
              child: ButtonBar(
                children: [
                  navigationButton(
                      Icons.chevron_left, (controller) => _goBack(controller)),
                  SizedBox(
                    width: 80,
                  ),
                  navigationButton(Icons.chevron_right,
                      (controller) => _goForward(controller)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navigationButton(
      IconData icon, Function(WebViewController) onPressed) {
    return FutureBuilder(
        future: _controller.future,
        builder: (context, AsyncSnapshot<WebViewController> snapshot) {
          if (snapshot.hasData) {
            return IconButton(
                icon: Icon(
                  icon,
                  color: Colors.black,
                  size: 50,
                ),
                onPressed: () => onPressed(snapshot.requireData));
          } else {
            return Container();
          }
        });
  }

  Future<void> _goBack(WebViewController controller) async {
    final canGoBack = await controller.canGoBack();

    if (canGoBack) {
      controller.goBack();
    }
  }

  void _goForward(WebViewController controller) async {
    final canGoForward = await controller.canGoForward();

    if (canGoForward) {
      controller.goForward();
    }
  }
}
