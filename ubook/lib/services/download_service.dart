// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/data/models/download_task.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/directory_utils.dart';

class DownloadService {
  DownloadService(
      {required JsRuntime jsRuntime,
      required DatabaseService databaseService,
      required ExtensionsService extensionsService})
      : _jsRuntime = jsRuntime,
        _extensionsService = extensionsService,
        _databaseService = databaseService;

  final JsRuntime _jsRuntime;
  final ExtensionsService _extensionsService;
  final DatabaseService _databaseService;

  void onInit() async {
    final task = await _databaseService.onGetDownloadTask();
    if (task != null) {
      await onStartDownload(task);
    }
  }

  Future<void> addDownload(Book book) async {
    final isExists = await _databaseService.onGetDownloadByBookId(book.id!);
    if (isExists == null) {
      _databaseService.onInsertDownload(DownloadTask(
          bookId: book.id!,
          status: DownloadStatus.init,
          totalChapterDownload: book.totalChapters,
          totalDownloaded: 0,
          updateAt: DateTime.now()));
    }
  }

  Future<void> onStartDownload(DownloadTask downloadTask) async {
    final book = await _databaseService.onGetBookById(downloadTask.bookId);
    if (book == null) return;
    final chapters = await _databaseService.getChaptersDownload(book.id!);
    final extensionBook =
        _extensionsService.getExtensionBySource(book.getSourceByBookUrl);
    if (extensionBook == null) return;
    final dowTask = DownloadBook(
      extension: extensionBook,
      jsRuntime: _jsRuntime,
      downloadTask: downloadTask,
      onChangeTask: (callback) async {
        if (callback.chapter != null) {
          await Future.wait([
            _databaseService.onInsertChapter(callback.chapter!),
            _databaseService.onUpdateDownload(callback.task)
          ]);
        } else {
          await _databaseService.onUpdateDownload(callback.task);
        }
      },
      onDownloaded: () async {
        onInit();
      },
    );
    dowTask.onStartDownload(chapters);
  }
}

class CallbackTask {
  final DownloadTask task;
  final Chapter? chapter;
  CallbackTask({
    required this.task,
    this.chapter,
  });
}

class DownloadBook {
  final Extension extension;
  final JsRuntime jsRuntime;

  DownloadTask downloadTask;

  final ValueChanged<CallbackTask> onChangeTask;
  final VoidCallback onDownloaded;

  DownloadBook(
      {required this.extension,
      required this.jsRuntime,
      required this.onChangeTask,
      required this.onDownloaded,
      required this.downloadTask}) {
    Stream<void> sendRequest(DownloadChapter entry) {
      return entry
          ._onStartDownload()
          .asStream()
          .doOnData((chapter) {
            if (chapter != null) {
              downloadTask = downloadTask.copyWith(
                  status: DownloadStatus.downloading,
                  totalDownloaded: chapter.index + 1);
              onChangeTask
                  .call(CallbackTask(task: downloadTask, chapter: chapter));
            }
          })
          .doOnDone(() {
            debugPrint('DownloadChapter Done: ${downloadTask.totalDownloaded}');
            if (downloadTask.totalDownloaded ==
                downloadTask.totalChapterDownload) {
              downloadTask = downloadTask.copyWith(
                status: DownloadStatus.complete,
              );
              onChangeTask.call(CallbackTask(
                task: downloadTask,
              ));
              onDownloaded();
            }
          })
          .onErrorResumeNext(const Stream.empty())
          .doOnCancel(
              () => debugPrint('DownloadChapter Cancel: ${downloadTask.id}'));
    }

    _subscription = requestController.stream
        .flatMap(sendRequest, maxConcurrent: 1)
        .listen(null);
  }

  final requestController = StreamController<DownloadChapter>();
  late final StreamSubscription<dynamic> _subscription;

  Future<List<String>> getContentsChapter(String chapterUrl) async {
    return await jsRuntime.chapter(
        url: chapterUrl, jsScript: extension.getChaptersScript);
  }

  void onStartDownload(List<Chapter> chapters) async {
    final dirPath =
        await DirectoryUtils.getDirectoryDownloadBook(downloadTask.bookId);
    for (var i = 0; i < chapters.length; i++) {
      requestController.add(DownloadChapter(
          chapter: chapters[i],
          dirPath: dirPath,
          onGetContentsChapters: getContentsChapter,
          dioClient: jsRuntime.getDioClient));
    }
  }

  void close() {
    _subscription.cancel().then((_) => requestController.close());
  }
}

class _ChapterContent {
  String content;
  int index;
  _ChapterContent({
    required this.content,
    required this.index,
  });
}

typedef OnGetContentsChapters = Future<List<String>> Function(String url);

class DownloadChapter {
  Chapter chapter;
  final DioClient _dioClient;
  int _totalContentDownloaded = 0;
  List<_ChapterContent> pathImage = [];
  final String dirPath;
  final OnGetContentsChapters onGetContentsChapters;
  late Completer<Chapter> _completer;

  DownloadChapter(
      {required this.chapter,
      required this.dirPath,
      DioClient? dioClient,
      required this.onGetContentsChapters})
      : _dioClient = dioClient ?? DioClient() {
    _completer = Completer.sync();
  }

  void _handlerDownload(
      {required int index, required List<int> bytes, required bool isError}) {
    _totalContentDownloaded++;
    if (bytes.isNotEmpty) {
      try {
        final id = const Uuid().v1();
        final pathFile = "$dirPath/$id.jpg";
        File(pathFile)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes);
        pathImage.add(_ChapterContent(content: pathFile, index: index));
      } catch (error) {
        // print(error);
      }
    }
    if (_totalContentDownloaded == chapter.content.length) {
      _handlerDownloadedChapter();
    }
  }

  void _handlerDownloadedChapter() {
    pathImage.sort((a, b) => a.index.compareTo(b.index));
    final List<String> contents = pathImage.map((e) => e.content).toList();
    _completer.complete(chapter.copyWith(content: contents));
  }

  Future<Chapter?> _onStartDownload() async {
    final lst = await onGetContentsChapters(chapter.url);
    final uri = Uri.parse(chapter.url);
    final options = Options(
        headers: {"referer": "${uri.scheme}://${uri.host}"},
        responseType: ResponseType.bytes);
    chapter = chapter.copyWith(content: lst);
    for (var i = 0; i < lst.length; i++) {
      final item = lst[i];
      _dioClient.getWithConcurrent(item, options: options).then((value) {
        if (value is List<int>) {
          _handlerDownload(index: i, bytes: value, isError: false);
        } else {
          _handlerDownload(index: i, bytes: [], isError: true);
        }
      }).catchError((error) {
        _handlerDownload(index: i, bytes: [], isError: true);
      });
    }
    return _completer.future;
  }
}
