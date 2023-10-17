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
      required this.extension})
      : _databaseService = databaseService,
        _jsRuntime = extensionManager.jsRuntime,
        super(DetailBookState(
            book: book, statusType: StatusType.init, isBookmark: false));

  final _logger = Logger("DetailBookCubit");

  final DatabaseService _databaseService;
  final Extension extension;
  final JsRuntime _jsRuntime;
  int? _idBook;
  void onInit() async {
    await Future.wait([getDetailBook(), getBookInBookmarks()]);
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
    }
    emit(state.copyWith(isBookmark: bookmark != null));
  }

  void actionBookmark() async {
    if (state.isBookmark) {
      final isDelete = await _databaseService.onDeleteBook(_idBook!);
      if (isDelete) {
        emit(state.copyWith(isBookmark: false));
      }
    } else {
      final idBook = await _databaseService.onInsertBook(state.book);
      if (idBook is int) {
        emit(state.copyWith(isBookmark: true));
        _idBook = idBook;
      }
    }
  }
}
