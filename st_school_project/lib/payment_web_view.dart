
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/api/repository/api_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

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
              onNavigationRequest: (request) async {
                final url = request.url;
                final baseUrl = ApiUrl.baseUrl;
                AppLogger.log.i("Navigating to: $url");

                if (url.startsWith("upi://") || url.startsWith("intent://")) {
                  try {
                    String finalUrl = url;

                    // Convert intent:// to upi:// if needed
                    if (url.startsWith("intent://")) {
                      finalUrl = url.replaceFirst("intent://", "upi://");
                    }

                    final uri = Uri.parse(finalUrl);
                    AppLogger.log.i("Launching UPI intent: $finalUrl");

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      AppLogger.log.e("No app can handle: $finalUrl");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No UPI app found!')),
                      );
                    }
                  } catch (e) {
                    AppLogger.log.e("Error launching UPI intent: $e");
                  }

                  return NavigationDecision.prevent;
                }

                if (url.startsWith("${baseUrl}/payment/success")) {
                  final uri = Uri.parse(url);
                  final orderId = uri.queryParameters["orderId"];
                  final tid = uri.queryParameters["tid"];
                  Navigator.pop(context, {
                    "status": "success",
                    "orderId": orderId,
                    "tid": tid,
                  });
                  return NavigationDecision.prevent;
                }

                if (url.startsWith("${baseUrl}/payment/failure")) {
                  final uri = Uri.parse(url);
                  final orderId = uri.queryParameters["orderId"];
                  final reason = uri.queryParameters["reason"];
                  Navigator.pop(context, {
                    "status": "failure",
                    "orderId": orderId,
                    "reason": reason,
                  });
                  return NavigationDecision.prevent;
                }
                if (url.startsWith("${baseUrl}/payment/cancelled")) {
                  final uri = Uri.parse(url);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/api/repository/api_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();

    AppLogger.log.i("PaymentWebView initial load URL => ${widget.url}");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // Fires when a page starts loading
          onPageStarted: (url) {
            AppLogger.log.i("onPageStarted => $url");
          },

          // Fires when a page finishes loading
          onPageFinished: (url) {
            AppLogger.log.i("onPageFinished => $url");
          },

          // ✅ Catches HTTP status errors like 404, 500, etc.
          onHttpError: (HttpResponseError error) {
            final reqUrl = error.request?.uri.toString() ?? "unknown-url";
            final code = error.response?.statusCode;

            AppLogger.log.e("onHttpError => url=$reqUrl statusCode=$code");

            // ignore favicon/images
            final u = reqUrl.toLowerCase();
            final ignore = u.contains("favicon.ico") || u.endsWith(".png");
            if (ignore) return;

            _showSnack("HTTP $code for $reqUrl");
          },

          onWebResourceError: (WebResourceError error) {
            // Some versions have error.url, some don’t.
            // If your version doesn't have url, remove that line.
            final u = (error.url is Uri) ? (error.url as Uri).toString() : "${error.url}";

            AppLogger.log.e(
              "onWebResourceError => "
                  "type: ${error.errorType}, "
                  "code: ${error.errorCode}, "
                  "desc: ${error.description}, "
                  "url: $u",
            );

            _showSnack("Load error: ${error.description}");
          },

          onNavigationRequest: (request) async {
            final url = request.url;
            final baseUrl = ApiUrl.baseUrl;

            AppLogger.log.i("onNavigationRequest => $url");

            // ✅ Handle UPI links (upi:// or intent://)
            if (url.startsWith("upi://") || url.startsWith("intent://")) {
              try {
                String finalUrl = url;

                // Convert intent:// to upi:// if needed
                if (url.startsWith("intent://")) {
                  finalUrl = url.replaceFirst("intent://", "upi://");
                }

                final uri = Uri.parse(finalUrl);
                AppLogger.log.i("Launching UPI intent => $finalUrl");

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  AppLogger.log.e("No UPI app can handle => $finalUrl");
                  _showSnack("No UPI app found!");
                }
              } catch (e, st) {
                AppLogger.log.e("Error launching UPI intent => $e\n$st");
                _showSnack("UPI open failed");
              }

              return NavigationDecision.prevent;
            }

            // ✅ Better: check by PATH also (safer if domain differs)
            final uri = Uri.tryParse(url);
            if (uri != null) {
              // success
              if (url.startsWith("$baseUrl/payment/success") ||
                  uri.path.startsWith("/payment/success")) {
                final orderId = uri.queryParameters["orderId"];
                final tid = uri.queryParameters["tid"];

                AppLogger.log.i("Payment success => orderId=$orderId tid=$tid");

                Navigator.pop(context, {
                  "status": "success",
                  "orderId": orderId,
                  "tid": tid,
                });
                return NavigationDecision.prevent;
              }

              // failure
              if (url.startsWith("$baseUrl/payment/failure") ||
                  uri.path.startsWith("/payment/failure")) {
                final orderId = uri.queryParameters["orderId"];
                final reason = uri.queryParameters["reason"];

                AppLogger.log.i("Payment failure => orderId=$orderId reason=$reason");

                Navigator.pop(context, {
                  "status": "failure",
                  "orderId": orderId,
                  "reason": reason,
                });
                return NavigationDecision.prevent;
              }

              // cancelled
              if (url.startsWith("$baseUrl/payment/cancelled") ||
                  uri.path.startsWith("/payment/cancelled")) {
                final orderId = uri.queryParameters["orderId"];
                final reason = uri.queryParameters["reason"];

                AppLogger.log.i("Payment cancelled => orderId=$orderId reason=$reason");

                Navigator.pop(context, {
                  "status": "failure",
                  "orderId": orderId,
                  "reason": reason,
                });
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}*/
