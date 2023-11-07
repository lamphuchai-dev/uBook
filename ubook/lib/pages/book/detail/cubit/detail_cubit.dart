import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/services/index.dart';
import 'package:ubook/utils/logger.dart';
import 'package:ubook/widgets/widgets.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(
      {required String bookUrl,
      required ExtensionsService extensionManager,
      required DatabaseService databaseService,
      required JsRuntime jsRuntime})
      : _bookUrl = bookUrl,
        _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        _extensionManager = extensionManager,
        super(DetailInitial());

  final _logger = Logger("DetailBookCubit");

  final DatabaseService _databaseService;
  Extension? _extension;
  final JsRuntime _jsRuntime;
  final ExtensionsService _extensionManager;
  final String _bookUrl;

  final FToast fToast = FToast();

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  Extension get getExtension => _extension!;

  void onInit() async {
    emit(DetailLoading());
    final sourceBook = _bookUrl.getSourceByUrl;
    if (sourceBook == null) {
      emit(const DetailError(message: "Book url error"));
      return;
    }
    _extension = _extensionManager.getExtensionBySource(sourceBook);
    if (_extension == null) {
      emit(const DetailError(message: "Extension not found"));
      return;
    }

    int? booId;
    final bookInBookmark = await _databaseService.getBookByUrl(_bookUrl);
    if (bookInBookmark != null) {
      booId = bookInBookmark.id;
    }

    Book? bookExt = await getDetailByBookUrl();

    if (bookExt == null) {
      emit(const DetailError(message: "Error get data book"));
      return;
    }

    bookExt = bookExt.copyWith(id: booId, bookmark: booId != null);
    if (!isClosed) {
      emit(DetailLoaded(book: bookExt));
    }
  }

  Future<Book?> getDetailByBookUrl() async {
    try {
      final result = await _jsRuntime.detail(
          url: _bookUrl,
          jsScript: _extension!.getDetailScript,
          extType: _extension!.metadata.type);

      return result;
    } catch (error) {
      _logger.error(error, name: "getDetailBook");
      return null;
    }
  }

  Future<void> addBookmark() async {
    final state = this.state;
    if (state is! DetailLoaded) return;
    try {
      final bookId = await _databaseService.onInsertBook(state.book);
      final chapters = await _jsRuntime.getChapters(
        url: _bookUrl,
        bookId: bookId,
        jsScript: _extension!.getChaptersScript,
      );

      if (chapters.isEmpty) return;
      await _databaseService.insertChapters(chapters);
      emit(state.copyWith(
          book: state.book.copyWith(id: bookId, bookmark: true)));

      fToast.showToast(
        child: ToastWidget(msg: "bookmark.add_complete".tr()),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (error) {
      _logger.error(error, name: "addBookmark");

      fToast.showToast(
        child: ToastWidget(msg: "bookmark.add_failed".tr()),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
}
