import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/extensions_service.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit(
      {required DatabaseService databaseService,
      required ExtensionsService extensionsService})
      : _databaseService = databaseService,
        _extensionsService = extensionsService,
        super(const BookmarksState(books: [], statusType: StatusType.init)) {
    _booksSubscription = _databaseService.bookStream.listen((event) {
      onInit();
    });
  }

  final DatabaseService _databaseService;
  final ExtensionsService _extensionsService;

  late StreamSubscription _booksSubscription;
  void onInit() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));

      final books = await _databaseService.getBooks();

      emit(state.copyWith(statusType: StatusType.loaded, books: books));
    } catch (error) {
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

  (List<Book> booksSlider, List<Book> booksGrid) getBooks(List<Book> books) {
    List<Book> booksSlider = [];
    List<Book> booksGrid = [];
    if (books.length <= 3) {
      return (books, booksGrid);
    } else {
      booksSlider = books.getRange(0, 3).toList();
      booksGrid = books.getRange(3, books.length).toList();
    }
    return (booksSlider, booksGrid);
  }

  String getNameExtensionBySource(String source) {
    final tmp = _extensionsService.getExtensionBySource(source);
    return tmp?.metadata.name ?? "";
  }

  Future<bool> onTapDelete(Book book) async {
    final isDelete = await _databaseService.onDeleteBook(book.id!);
    if (isDelete) {
      final books =
          state.books.where((el) => el.bookUrl == book.bookUrl).toList();
      emit(state.copyWith(books: books));
    }
    return isDelete;
  }

  Extension? getExtension(String source) {
    return _extensionsService.getExtensionBySource(source);
  }

  @override
  Future<void> close() {
    _booksSubscription.cancel();
    return super.close();
  }
}
