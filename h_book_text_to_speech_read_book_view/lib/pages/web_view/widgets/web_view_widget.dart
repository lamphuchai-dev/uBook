import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:h_book/utils/logger.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({super.key});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final GlobalKey webViewKey = GlobalKey();
  final _logger = Logger("_WebViewWidgetState");

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      useShouldInterceptRequest: true,
      allowsInlineMediaPlayback: true,
      cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
      sharedCookiesEnabled: true);

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest:
                  URLRequest(url: WebUri("https://metruyencv.com/truyen")),
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                return NavigationActionPolicy.ALLOW;
              },
              shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
                return null;

                // return
              },
              onAjaxReadyStateChange: (controller, ajaxRequest) async {
                if (ajaxRequest.url
                        .toString()
                        .contains("api.truyen.onl/v2/chapters") &&
                    ajaxRequest.status == 200 &&
                    ajaxRequest.responseText != null &&
                    ajaxRequest.responseText?.trim() != "") {
                  print(ajaxRequest.responseText);
                }
                return AjaxRequestAction.PROCEED;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });

                final html = await controller.getHtml();
                // _logger.log(html);
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          // ElevatedButton(
          //   child: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     webViewController?.goBack();
          //   },
          // ),
          // ElevatedButton(
          //   child: const Icon(Icons.arrow_forward),
          //   onPressed: () {
          //     webViewController?.goForward();
          //   },
          // ),
          ElevatedButton(
            child: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
          ElevatedButton(
              onPressed: () async {
                // final html = webViewController.webStorage.
                // <em>Đang tải thêm nội dung, nếu đợi quá lâu xin vui lòng tải lại trang</em <em>"Vui lòng đăng nhập để đọc tiếp nội dung"</em>

                final html = await webViewController?.getHtml();
                if (html!.contains(
                        "<em>Đang tải thêm nội dung, nếu đợi quá lâu xin vui lòng tải lại trang</em") ||
                    html.contains(
                        "<em>Vui lòng đăng nhập để đọc tiếp nội dung</em>")) {
                  print("object");
                } else {
                  print("done");
                }
              },
              child: const Text("Check")),
          ElevatedButton(
            child: const Icon(Icons.login),
            onPressed: () async {
              final resultLogin =
                  await webViewController!.callAsyncJavaScript(functionBody: '''
                    var button = document.querySelector(".nh-navbar__action--menu");
                    // Kiểm tra xem nút có tồn tại không
                    if (button) {
                      // Kích hoạt sự kiện click trên nút
                      button.click();
                      var model = document.querySelector(".nh-sidebar");
                      for (const a of model.querySelectorAll("a")) {
                        if (a.textContent.includes("Đăng nhập")) {
                          a.click();
                          await new Promise((resolve) => setTimeout(resolve, 1000));

                          var emailInput = document.getElementById("email");
                          var passwordInput = document.getElementById("password");
                          var remember = document.getElementById("remember");
                          if (emailInput && passwordInput) {
                            emailInput.value = "lamphuchai.dev@gmail.com";
                            passwordInput.value = "Laiphucham@52";
                            var inputEvent = new Event('input', { bubbles: true });
                            emailInput.dispatchEvent(inputEvent);
                            passwordInput.dispatchEvent(inputEvent);

                            // Tạo sự kiện change (thay đổi giá trị)
                            var changeEvent = new Event('change', { bubbles: true });
                            emailInput.dispatchEvent(changeEvent);
                            passwordInput.dispatchEvent(changeEvent);

                            remember.checked = true;
                            await new Promise((resolve) => setTimeout(resolve, 1000));
                            var loginButton = document.querySelector(".btn-primary");
                            // Kiểm tra xem phần tử có tồn tại không
                            if (loginButton) {
                              // Kích hoạt sự kiện click trên nút đăng nhập
                              loginButton.click();
                              return true;
                            } else {
                              console.log("Không tìm thấy phần tử button");
                            }
                          }
                        }
                      }
                      return false;
                      console.log("END");
                    } else {
                      console.log("Không tìm thấy nút");
                      return false;
                    }
                    return false;
                  ''');

              if (resultLogin?.value) {
                _logger.log(resultLogin?.value);
              }
              _logger.log(resultLogin);
            },
          ),
        ],
      ),
    ]));
  }
}
