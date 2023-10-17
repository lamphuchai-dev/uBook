import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit(
      {required this.book,
      required this.extensionModel,
      required JsRuntime jsRuntime})
      : _jsRuntime = jsRuntime,
        super(const ChaptersState(
            chapters: [],
            statusType: StatusType.init,
            sortType: SortChapterType.newChapter));
  final _logger = Logger("ChaptersCubit");
  final Book book;
  final JsRuntime _jsRuntime;

  final Extension extensionModel;

  void onInit() async {
    emit(state.copyWith(statusType: StatusType.loading));
    try {
      List<Chapter> chapters = await _jsRuntime.getChapters(
          url: book.bookUrl,
          jsScript:
              DirectoryUtils.getJsScriptByPath(extensionModel.script.chapters));
      chapters = sort(chapters, SortChapterType.newChapter);
      emit(state.copyWith(
          chapters: chapters,
          sortType: SortChapterType.newChapter,
          statusType: StatusType.loaded));
    } catch (error) {
      emit(state.copyWith(statusType: StatusType.error));
      _logger.error(error, name: "onInit");
    }
  }

  void sortChapterType(SortChapterType type) {
    final chapters = sort(state.chapters, type);
    emit(state.copyWith(chapters: chapters, sortType: type));
  }

  List<Chapter> sort(List<Chapter> list, SortChapterType type) {
    if (type == SortChapterType.newChapter) {
      list.sort((a, b) => b.index.compareTo(a.index));
    } else {
      list.sort((a, b) => a.index.compareTo(b.index));
    }
    print(type);
    return list;
  }
}
