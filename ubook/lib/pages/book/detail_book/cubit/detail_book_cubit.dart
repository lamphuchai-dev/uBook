import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

part 'detail_book_state.dart';

class DetailBookCubit extends Cubit<DetailBookState> {
  DetailBookCubit(
      {required Book book,
      required ExtensionsService extensionManager,
      required DatabaseService databaseService,
      required JsRuntime jsRuntime,
      required this.extension})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        super(DetailBookState(
            book: book, statusType: StatusType.init, isBookmark: false));

  final _logger = Logger("DetailBookCubit");

  final DatabaseService _databaseService;
  final Extension extension;
  final JsRuntime _jsRuntime;
  int? _idBook;
  void onInit() async {
    // await Future.wait([getDetailBook(), getBookInBookmarks()]);
    await getDetailBook();
    await getBookInBookmarks();
  }

  Future<void> getDetailBook() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));
      final result = await _jsRuntime.detail(
          url: state.book.bookUrl,
          jsScript: DirectoryUtils.getJsScriptByPath(extension.script.detail),
          extType: extension.metadata.type);
      emit(state.copyWith(book: result, statusType: StatusType.loaded));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

  Future<void> getBookInBookmarks() async {
    final bookmark = await _databaseService.getBookByUrl(state.book.bookUrl);
    if (bookmark != null) {
      _idBook = bookmark.id;
      final book = state.book.copyWith(
          id: bookmark.id, readBook: bookmark.readBook, bookmark: true);
      emit(state.copyWith(isBookmark: true, book: book));
    } else {
      emit(state.copyWith(isBookmark: false));
    }
  }

  void actionBookmark() async {
    if (state.isBookmark) {
      final isDelete = await _databaseService.onDeleteBook(_idBook!);
      if (isDelete) {
        await _databaseService.deleteChaptersByBookId(_idBook!);
        emit(state.copyWith(isBookmark: false));
      }
    } else {
      await add();
    }
  }

  Future<bool> add() async {
    try {
      final bookId = await _databaseService.onInsertBook(state.book);
      if (bookId == null) return false;
      final chapters = await _jsRuntime.getChapters(
        url: state.book.bookUrl,
        bookId: bookId,
        jsScript: DirectoryUtils.getJsScriptByPath(extension.script.chapters),
      );

      if (chapters.isEmpty) return false;
      final listId = await _databaseService.insertChapters(chapters);

      emit(state.copyWith(
          isBookmark: true, book: state.book.copyWith(id: bookId)));
      return listId.length == chapters.length;
    } catch (error) {
      return false;
    }
  }
}
