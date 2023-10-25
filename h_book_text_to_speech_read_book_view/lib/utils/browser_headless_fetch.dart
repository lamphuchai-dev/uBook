import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/data/models/book.dart';
import 'package:h_book/data/models/chapter.dart';
import 'package:h_book/data/models/page_plugin.dart';
import 'package:h_book/utils/base_fetch.dart';

enum StatusHeadLessBrowser {
  init,
  loading,
  loadMore,
  loadingSuccess,
  loadMoreSuccess,
  loadAddSuccess,
  error
}

enum ActionLoading { loading, loadMore }

class HeadLessBrowserValues<T> {
  final StatusHeadLessBrowser status;
  final List<T>? values;
  const HeadLessBrowserValues({
    required this.status,
    this.values,
  });

  HeadLessBrowserValues copyWith({
    StatusHeadLessBrowser? status,
    List<Book>? values,
  }) {
    return HeadLessBrowserValues(
      status: status ?? this.status,
      values: values ?? this.values,
    );
  }
}

class FetchBrowserHeadlessPage<T> extends BaseFetch {
  FetchBrowserHeadlessPage({required this.pagePlugin, required this.modelName});
  final PagePlugin pagePlugin;
  final String modelName;
  int _indexPage = 1;
  HeadlessInAppWebView? _headlessWebView;

  Timer? _closeFetchTimer;

  int _numberCountFetch = 2;

  ActionLoading _actionLoading = ActionLoading.loading;

  String _previousFetchURL = "";

  final StreamController<HeadLessBrowserValues> _booksStreamController =
      StreamController.broadcast();
  @override
  Stream get stream => _booksStreamController.stream;

  List<UserScript> listUserScript = [];
  List<String> loadStopScript = [];

  void _getScript() {
    for (var scripts in pagePlugin.scripts) {
      switch (scripts.injectionTime) {
        case "UserScript":
          listUserScript.add(UserScript(
              source: scripts.script,
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END));
          break;
        case "StopLoadPage":
          loadStopScript.add(scripts.script);
          break;
        default:
          break;
      }
    }
    "listUserScript ::: ${listUserScript.length}".log(tag: "getUserScript");
    "scriptLoadStop ::: ${loadStopScript.length}".log(tag: "getUserScript");
  }

  URLRequest get _urlPage {
    String url = pagePlugin.url;
    if (pagePlugin.replacePage != "") {
      url = url.replaceAll(pagePlugin.replacePage, "$_indexPage");
    }
    return URLRequest(url: WebUri(url));
  }

  @override
  Future<void> onInit() async {
    _getScript();
    _headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: _urlPage,
      initialUserScripts: UnmodifiableListView(listUserScript),
      initialSettings: InAppWebViewSettings(
        useShouldInterceptAjaxRequest: true,
        loadsImagesAutomatically: false,
        allowsPictureInPictureMediaPlayback: false,
      ),
      onWebViewCreated: (controller) async {
        print(await controller.getUrl());
        "onWebViewCreated".log(tag: "_initHeadlessWeb");
      },
      onAjaxReadyStateChange:
          (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
        if (ajaxRequest.url.toString().contains(pagePlugin.regexp) &&
            ajaxRequest.status == 200 &&
            ajaxRequest.responseText != null &&
            ajaxRequest.responseText?.trim() != "" &&
            _previousFetchURL != ajaxRequest.url.toString()) {
          _handlerCallJs(controller, ajaxRequest.url.toString(),
              ajaxRequest.responseText!);
          // print(ajaxRequest.url.toString());
        }
        return AjaxRequestAction.PROCEED;
      },
      onLoadStart: (controller, url) async {
        url.toString().log(tag: "onLoadStart");
      },
      onLoadStop: (controller, url) async {
        if (loadStopScript.isNotEmpty) {
          await Future.forEach(loadStopScript, (element) async {
            final tmp =
                await controller.callAsyncJavaScript(functionBody: element);
            print(tmp);
          });
        }
      },
    );
  }

  void _handlerCallJs(
      InAppWebViewController controller, String url, String data,
      {int repeat = 2}) async {
    try {
      try {
        json.decode(data);
        _previousFetchURL = url.toString();
        await controller
            .evaluateJavascript(source: 'execute($data)')
            .then((result) {
          if (result != null) {
            switch (modelName) {
              case "Book":
                _indexPage = result["nextPage"];
                final books =
                    result["books"].map((e) => Book.fromMap(e)).toList();
                _handleSuccess(List<T>.from(books));

                break;
              case "Chapter":
                final chapters = result.map((e) => Chapter.fromMap(e)).toList();
                _handleSuccess(List<T>.from(chapters));

                break;
              default:
                _booksStreamController.add(const HeadLessBrowserValues(
                    status: StatusHeadLessBrowser.error));
                break;
            }
          } else if (repeat > 0) {
            "Repeat :: $repeat".log(tag: "_handlerCallJs");
            _handlerCallJs(controller, url, data, repeat: repeat - 1);
          } else {
            _handleSuccess([]);
          }
        });
      } catch (error) {
        error.toString().log(tag: "error");
      }
    } catch (error) {
      error.toString().log(tag: "error");
      _handleError();
    }
  }

  void _handleSuccess(List<T> listBook) {
    _numberCountFetch -= 1;
    if (_numberCountFetch == 1) {
      _booksStreamController.add(HeadLessBrowserValues<T>(
          status: _actionLoading == ActionLoading.loading
              ? StatusHeadLessBrowser.loadingSuccess
              : StatusHeadLessBrowser.loadMoreSuccess,
          values: listBook));
      if (modelName != "Chapter") {
        _nextPage();
      }
    }
    if (_numberCountFetch == 0) {
      _booksStreamController.add(HeadLessBrowserValues<T>(
          status: StatusHeadLessBrowser.loadAddSuccess, values: listBook));
      _closeFetchTimer?.cancel();
    }
  }

  void _handleError() {
    _booksStreamController
        .add(const HeadLessBrowserValues(status: StatusHeadLessBrowser.error));
  }

  void _closeFetchByTimer() {
    if (_closeFetchTimer != null) _closeFetchTimer?.cancel();
    _closeFetchTimer = Timer(const Duration(seconds: 20), () {
      _headlessWebView?.dispose();

      _booksStreamController.add(
          const HeadLessBrowserValues(status: StatusHeadLessBrowser.error));
    });
  }

  void _nextPage() {
    _headlessWebView?.webViewController?.loadUrl(urlRequest: _urlPage);
  }

  @override
  Future<void> onFetch() async {
    await _headlessWebView?.dispose();
    await _headlessWebView?.run();
    _previousFetchURL = "";
    _numberCountFetch = 2;
    _indexPage = 1;
    _actionLoading = ActionLoading.loading;
    _closeFetchByTimer();
    _booksStreamController.add(
        const HeadLessBrowserValues(status: StatusHeadLessBrowser.loading));
  }

  @override
  Future<void> onLoadMore() async {
    _numberCountFetch = 2;
    _nextPage();
    _closeFetchByTimer();
    _actionLoading = ActionLoading.loadMore;
    _booksStreamController.add(
        const HeadLessBrowserValues(status: StatusHeadLessBrowser.loadMore));
  }

  @override
  Future<void> dispose() async {
    await _headlessWebView?.dispose();
    _closeFetchTimer?.cancel();
    await _booksStreamController.close();
  }
}
