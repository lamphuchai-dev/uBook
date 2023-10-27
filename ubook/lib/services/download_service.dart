// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/directory_utils.dart';

class DownloadService {
  DownloadService({required JsRuntime jsRuntime}) : _jsRuntime = jsRuntime;
  late JsRuntime _jsRuntime;
  List<DownloadTask> _downloads = [];

  Future<List<Chapter>> getChaptersByBook(DownloadTask downloadTask) async {
    final jsScript =
        DirectoryUtils.getJsScriptByPath(downloadTask.extension.script.detail);
    final chapters = await _jsRuntime.getChapters(
        url: downloadTask.book.bookUrl, jsScript: jsScript);
    return chapters;
  }
}

class DownloadTask {
  final Extension extension;
  final Book book;
  DownloadTask({
    required this.extension,
    required this.book,
  });
}
