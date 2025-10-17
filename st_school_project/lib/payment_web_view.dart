import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                print("Navigating to: ${request.url}");

                final uri = Uri.parse(request.url);

                // ✅ Payment Success
                if (request.url.startsWith(
                  "https://backend.stjosephmatricschool.com/payment/success",
                  //   'https://school-back-end-594f59bea6cb.herokuapp.com',
                )) {
                  final orderId = uri.queryParameters["orderId"];
                  final tid = uri.queryParameters["tid"];
                  Navigator.pop(context, {
                    "status": "success",
                    "orderId": orderId,
                    "tid": tid,
                  });
                  return NavigationDecision.prevent;
                }

                // ❌ Payment Failure
                if (request.url.startsWith(
                  "https://backend.stjosephmatricschool.com/payment/failure",
                  //   'https://school-back-end-594f59bea6cb.herokuapp.com',
                )) {
                  final orderId = uri.queryParameters["orderId"];
                  final reason = uri.queryParameters["reason"];
                  Navigator.pop(context, {
                    "status": "failure",
                    "orderId": orderId,
                    "reason": reason,
                  });
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onPageFinished: (url) {
  //           print("Page finished loading: $url");
  //           if (url.contains("payment-success")) {
  //             // Payment completed
  //             Navigator.pop(context, true); // Return success
  //           }
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.url));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
