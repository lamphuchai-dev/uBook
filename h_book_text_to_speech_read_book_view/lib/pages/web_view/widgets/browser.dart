import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:h_book/app/extensions/context_extension.dart';
import 'package:h_book/app/extensions/log_extension.dart';
import 'package:h_book/utils/logger.dart';

class BrowserWidget extends StatefulWidget {
  const BrowserWidget({super.key});

  @override
  State<BrowserWidget> createState() => _BrowserWidgetState();
}

class _BrowserWidgetState extends State<BrowserWidget> {
  HeadlessInAppWebView? _headlessWebView;
  final _logger = Logger("_WebViewWidgetState");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _headlessWebView = HeadlessInAppWebView(
                initialSize: Size(context.height, context.height),
                initialUrlRequest: URLRequest(
                    url: WebUri(
                        "https://metruyencv.net/truyen/nga-tai-than-bi-phuc-to-ly-thiem-dao/chuong-1135")),
                // initialUserScripts: UnmodifiableListView(listUserScript),
                initialSettings: InAppWebViewSettings(
                    useShouldInterceptAjaxRequest: true,
                    useOnLoadResource: false,
                    loadsImagesAutomatically: false,
                    allowsPictureInPictureMediaPlayback: false,
                    userAgent:
                        "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"),
                onWebViewCreated: (controller) async {
                  print(await controller.getUrl());
                  "onWebViewCreated".log(tag: "_initHeadlessWeb");
                },
                onLoadResource: (controller, resource) {
                  _logger.log(resource.url);
                },
                onAjaxReadyStateChange: (InAppWebViewController controller,
                    AjaxRequest ajaxRequest) async {
                  // if (ajaxRequest.url.toString().contains(pagePlugin.regexp) &&
                  //     ajaxRequest.status == 200 &&
                  //     ajaxRequest.responseText != null &&
                  //     ajaxRequest.responseText?.trim() != "" &&
                  //     _previousFetchURL != ajaxRequest.url.toString()) {
                  //   _handlerCallJs(controller, ajaxRequest.url.toString(),
                  //       ajaxRequest.responseText!);
                  //   // print(ajaxRequest.url.toString());
                  // }
                  return AjaxRequestAction.PROCEED;
                },
                onLoadStart: (controller, url) async {
                  // url.toString().log(tag: "onLoadStart");
                },
                onLoadStop: (controller, url) async {
                  // if (loadStopScript.isNotEmpty) {
                  //   await Future.forEach(loadStopScript, (element) async {
                  //     final tmp = await controller.callAsyncJavaScript(
                  //         functionBody: element);
                  //     print(tmp);
                  //   });
                  // }
                  _logger.log("onLoadStop");

                  final resultLogin = await _headlessWebView?.webViewController!
                      .callAsyncJavaScript(functionBody: '''
                    var button = document.querySelector(".nh-navbar__action--menu");
                    // Kiểm tra xem nút có tồn tại không
                    if (button) {
                      // Kích hoạt sự kiện click trên nút
                      button.click();
                      var model = document.querySelector(".nh-sidebar");
                      for (const a of model.querySelectorAll("a")) {
                        if (a.textContent.includes("Hồ sơ")) {
                          return "HS"
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

                  // if (resultLogin?.value) {
                  //   _logger.log(resultLogin?.value);
                  // }
                  _logger.log(resultLogin);
                  final html = await controller.getHtml();
                  _logger.log(html);
                },
              );
              _headlessWebView?.run();
            },
            child: const Text("get")),
        ElevatedButton(
            onPressed: () async {
              final resultLogin = await _headlessWebView?.webViewController!
                  .callAsyncJavaScript(functionBody: '''
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
            child: const Text("LOGIN")),
        ElevatedButton(
            onPressed: () async {
              final html = await _headlessWebView?.webViewController?.getHtml();
              _logger.log(html);
            },
            child: Text("HTML"))
      ],
    );
  }
}
