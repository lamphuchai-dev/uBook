// ignore_for_file: unused_element, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:ubook/app/constants/assets.dart';
import 'package:ubook/data/models/genre.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

class JsRuntime {
  late JavascriptRuntime runtime;

  final _logger = Logger("JsRuntime");
  final _dioClient = DioClient();

  Future<bool> initRuntime() async {
    final jsExtension =
        await rootBundle.loadString(AppAssets.jsScriptExtension);
    _dioClient.enableCookie(dir: await DirectoryUtils.getDirectory);
    runtime = getJavascriptRuntime();
    runtime.onMessage('request', (dynamic args) async {
      _logger.log("request args ::: $args");

      final dataResponse = await _dioClient.request<String>(
        args[0],
        data: args[1]['data'],
        queryParameters: args[1]['queryParameters'] ?? {},
        options: Options(
          headers: args[1]['headers'] ?? {},
          method: args[1]['method'] ?? 'get',
        ),
      );

      return dataResponse;
    });

    runtime.onMessage('log', (dynamic args) {
      _logger.log(args, name: "LOG");
    });

    runtime.onMessage('querySelector', (dynamic args) {
      try {
        final content = args[0];
        final selector = args[1];
        final fun = args[2];
        final doc = parse(content).querySelector(selector);
        switch (fun) {
          case 'text':
            return doc?.text ?? '';
          case 'outerHTML':
            return doc?.outerHtml ?? '';
          case 'innerHTML':
            return doc?.innerHtml ?? '';
          default:
            return doc?.outerHtml ?? '';
        }
      } catch (error) {
        rethrow;
      }
    });

    runtime.onMessage('querySelectorAll', (dynamic args) async {
      try {
        final content = args[0];
        final selector = args[1];
        final doc = parse(content).querySelectorAll(selector);
        if (doc.isEmpty) return [];
        final elements = jsonEncode(doc.map((e) {
          return e.outerHtml;
        }).toList());
        return elements;
      } catch (error) {
        rethrow;
      }
    });

    runtime.onMessage('getElementById', (dynamic args) async {
      final content = args[0];
      final id = args[1];
      final fun = args[2];
      final doc = parse(content).getElementById(id);
      switch (fun) {
        case 'text':
          return doc?.text ?? '';
        case 'outerHTML':
          return doc?.outerHtml ?? '';
        case 'innerHTML':
          return doc?.innerHtml ?? '';
        default:
          return doc?.outerHtml ?? '';
      }
    });

    runtime.onMessage('getElementsByClassName', (dynamic args) async {
      final content = args[0];
      final className = args[1];
      final doc = parse(content).getElementsByClassName(className);
      if (doc.isEmpty) return [];
      final elements = jsonEncode(doc.map((e) {
        return e.outerHtml;
      }).toList());

      return elements;
    });

    runtime.onMessage('queryXPath', (args) {
      final content = args[0];
      final selector = args[1];
      final fun = args[2];

      final xpath = HtmlXPath.html(content);
      final result = xpath.queryXPath(selector);

      switch (fun) {
        case 'attr':
          return result.attr ?? '';
        case 'attrs':
          return jsonEncode(result.attrs);
        case 'text':
          return result.node?.text;
        case 'allHTML':
          return result.nodes
              .map((e) => (e.node as Element).outerHtml)
              .toList();
        case 'outerHTML':
          return (result.node?.node as Element).outerHtml;
        default:
          return result.node?.text;
      }
    });

    runtime.onMessage('removeSelector', (dynamic args) {
      final content = args[0];
      final selector = args[1];
      final doc = parse(content);
      doc.querySelectorAll(selector).forEach((element) {
        element.remove();
      });
      return doc.outerHtml;
    });

    runtime.onMessage('getAttributeText', (args) {
      final content = args[0];
      final selector = args[1];
      final attr = args[2];
      final doc = parse(content).querySelector(selector);
      return doc?.attributes[attr];
    });

    final result = runtime.evaluate(jsExtension);
    return result.isError;
  }

  Future<T> _runExtension<T>(Future<T> Function() fun) async {
    try {
      return await fun();
    } catch (e) {
      _logger.error(e, name: "_runExtension");
      rethrow;
    }
  }

  Future<List<Book>> listBook(
      {required String url,
      required int page,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>home("$url",$page))'));
      return jsResult.toJson
          .map<Book>((map) => Book.fromExtensionType(extType, map))
          .toList();
    });
  }

  Future<Book?> detail(
      {required String url,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>detail("$url"))'));
      return Book.fromExtensionType(extType, jsResult.toJson);
    });
  }

  Future<List<Chapter>> getChapters(
      {required String url, required String jsScript}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>chapters("$url"))'));
      List<Chapter> chapters =
          jsResult.toJson.map<Chapter>((map) => Chapter.fromMap(map)).toList();
      chapters.sort((a, b) => a.index.compareTo(b.index));
      return chapters;
    });
  }

  Future<List<String>> chapter(
      {required String url, required String jsScript}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await runtime.evaluateAsync('stringify(()=>chapter("$url"))'));
      return List<String>.from(jsResult.toJson);
    });
  }

  Future<List<Genre>> genre(
      {required String url, required String jsScript}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await runtime.evaluateAsync('stringify(()=>genre("$url"))'));
      return jsResult.toJson.map<Genre>((map) => Genre.fromMap(map)).toList();
    });
  }

  Future<List<Book>> search(
      {required String url,
      required String keyWord,
      int? page,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(await evaluateAsyncJsScript(
          'stringify(()=>search("$url","$keyWord",$page))'));
      return jsResult.toJson
          .map<Book>((map) => Book.fromExtensionType(extType, map))
          .toList();
    });
  }

  bool evaluateJsScript(String code, {bool exception = true}) {
    final jsEvalResult = runtime.evaluate(code);
    if (jsEvalResult.isError && exception) {
      throw const RuntimeException(RuntimeExceptionType.extensionScript);
    }
    return jsEvalResult.isError;
  }

  Future<JsEvalResult> evaluateAsyncJsScript(String code,
      {bool exception = true}) async {
    final jsEvalResult = await runtime.evaluateAsync(code);
    if (jsEvalResult.isError && exception) {
      throw const RuntimeException(RuntimeExceptionType.extensionScript);
    }
    return jsEvalResult;
  }
}

extension Json on JsEvalResult {
  dynamic get toJson {
    final json = jsonDecode(stringResult);
    if (json.runtimeType.toString() == "String") {
      return jsonDecode(json);
    }
    return json;
  }
}

enum RuntimeExceptionType { extensionScript, convertValue, other }

class RuntimeException implements Exception {
  final RuntimeExceptionType type;
  const RuntimeException(this.type);
}
