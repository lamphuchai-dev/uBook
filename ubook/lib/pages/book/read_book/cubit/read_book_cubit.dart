import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/device_utils.dart';
import 'package:ubook/utils/logger.dart';
import 'package:ubook/utils/system_utils.dart';
import 'package:ubook/widgets/widgets.dart';

part 'read_book_state.dart';

class ReadBookCubit extends Cubit<ReadBookState> {
  ReadBookCubit(
      {required Book book,
      required JsRuntime jsRuntime,
      required DatabaseService databaseService,
      required ExtensionsService extensionsService})
      : _jsRuntime = jsRuntime,
        _databaseService = databaseService,
        _extensionsService = extensionsService,
        super(ReadBookState(
            chapters: const [],
            statusType: StatusType.init,
            extensionStatus: ExtensionStatus.init,
            menuType: MenuType.base,
            controlStatus: ControlStatus.none,
            book: book));

  final _logger = Logger("ReadBookCubit");
  final JsRuntime _jsRuntime;
  final DatabaseService _databaseService;
  final ExtensionsService _extensionsService;

  bool _currentOnTouchScreen = false;
  late final AnimationController _menuAnimationController;

  Timer? chaptersSliderTime;

  Chapter? previousChapter;
  Chapter? nextChapter;

  Book get book => state.book;
  set setBook(Book book) => emit(state.copyWith(book: book));
  Extension? _extension;

  Extension get getExtension => _extension!;

  final FToast fToast = FToast();

  ValueNotifier<double> timeAutoScroll = ValueNotifier(10);
  Timer? sliderTimeAutoScroll;

  VoidCallback? handlerAutoScroll;

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  @override
  void onChange(Change<ReadBookState> change) {
    if (change.currentState.menuType != MenuType.autoScroll &&
        change.nextState.menuType == MenuType.autoScroll) {
      DeviceUtils.enableWakelock();
    } else if (change.currentState.menuType == MenuType.autoScroll &&
        change.nextState.menuType != MenuType.autoScroll) {
      DeviceUtils.disableWakelock();
    }

    if (change.currentState.readChapter != null &&
        change.nextState.readChapter != null &&
        change.currentState.readChapter?.chapter !=
            change.nextState.readChapter?.chapter) {
      // update read book
      if (book.bookmark) {
        final chapter = change.nextState.readChapter!.chapter;
        final readBook = ReadBook(
            index: chapter.index,
            titleChapter: chapter.title,
            nameExtension: _extension!.metadata.name);
        _databaseService.updateBook(book.copyWith(readBook: readBook));
      }
    }
    super.onChange(change);
  }

  void onInit(
      {required List<Chapter> chapters,
      Extension? extension,
      required int initReadChapter}) async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));
      _extension =
          _extensionsService.getExtensionBySource(book.getSourceByBookUrl);
      if (_extension == null) {
        emit(state.copyWith(
            extensionStatus: ExtensionStatus.noInstall,
            statusType: StatusType.loaded));
        return;
      }
      final bookmark = await _databaseService.getBookByUrl(book.bookUrl);
      if (bookmark != null) {
        setBook = bookmark;
      }
      // Check up lại bookUrl khi extension thay đổi source
      if (_extension!.metadata.source != book.getSourceByBookUrl) {
        final bookUrl = book.bookUrl
            .replaceAll(book.getSourceByBookUrl, _extension!.metadata.source);
        _databaseService.updateBook(book.copyWith(bookUrl: bookUrl));
        setBook = book.copyWith(bookUrl: bookUrl);
      }
      // Lấy chapters của book đã lưu trong local,update chapter khi có sự thay đổi
      // Khi từ page chapters -> readBook page
      if (book.bookmark && book.id != null) {
        final localChapters =
            await _databaseService.getChaptersByBookId(book.id!);
        if (chapters.isNotEmpty && chapters.length > localChapters.length) {
          // Lấy ra các chapters mới
          List<Chapter> newChapters =
              chapters.getRange(localChapters.length, chapters.length).toList();
          newChapters =
              newChapters.map((e) => e.copyWith(bookId: book.id)).toList();
          // Update vào database theo bookId
          await _databaseService.insertChapters(newChapters);
          chapters = await _databaseService.getChaptersByBookId(book.id!);
        } else {
          chapters = localChapters;
        }
      }

      if (chapters.isEmpty && initReadChapter > chapters.length) {
        emit(state.copyWith(
            statusType: StatusType.error,
            extensionStatus: ExtensionStatus.ready));
        return;
      }
      ReadChapter readChapter = ReadChapter(
          chapter: chapters[initReadChapter], status: StatusType.init);

      emit(state.copyWith(
          chapters: chapters,
          readChapter: readChapter.copyWith(status: StatusType.init),
          statusType: StatusType.loaded,
          extensionStatus: ExtensionStatus.ready));
      getContentsChapter();

      if (book.bookmark && book.id != null) {
        _databaseService.updateBook(book.copyWith(
            updateAt: DateTime.now(),
            readBook: ReadBook(
                index: readChapter.chapter.index,
                offsetLast: 0.0,
                titleChapter: readChapter.chapter.title,
                nameExtension: _extension!.metadata.name)));
      }

      state;
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

  // onTap vào màn hình để mở panel theo [ReadBookType]
  void onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  void setMenuAnimationController(AnimationController animationController) {
    _menuAnimationController = animationController;
  }

  bool get _isShowMenu =>
      _menuAnimationController.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  void onChangeIsShowMenu(bool value) async {
    if (value) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }
  }

  Future<void> onHideCurrentMenu() async {
    if (_menuAnimationController.status == AnimationStatus.completed) {
      await _menuAnimationController.reverse();
    }
  }

  void onChangeChaptersSlider(int value) {
    if (chaptersSliderTime != null) {
      chaptersSliderTime?.cancel();
    }

    chaptersSliderTime = Timer(const Duration(milliseconds: 500), () {
      final chapter = state.chapters[value];
      emit(state.copyWith(
          readChapter: ReadChapter(chapter: chapter, status: StatusType.init)));
    });
  }

  Future<void> getContentsChapter() async {
    _logger.log("getContentsChapter");
    calculateChapter();
    ReadChapter readChapter =
        state.readChapter!.copyWith(status: StatusType.loading);
    try {
      if (readChapter.chapter.content.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
            readChapter: readChapter.copyWith(status: StatusType.loaded)));
      } else {
        emit(state.copyWith(readChapter: readChapter));
        List result = await _jsRuntime.chapter(
            url: readChapter.chapter.url,
            jsScript: _extension!.getChapterScript);
        if (result.isNotEmpty) {
          if (result.first is String) {
            readChapter = readChapter.copyWith(
                chapter: readChapter.chapter.copyWith(
                  content: List<String>.from(result),
                ),
                status: StatusType.loaded);
          } else {
            try {
              final list = List<Map<String, dynamic>>.from(result);
              readChapter = readChapter.copyWith(
                  chapter: readChapter.chapter.copyWith(
                    contentVideo: list,
                  ),
                  status: StatusType.loaded);
            } catch (error) {
              readChapter = readChapter.copyWith(
                  chapter: readChapter.chapter, status: StatusType.error);
            }
          }
        } else {
          readChapter = readChapter.copyWith(status: StatusType.error);
        }

        List<Chapter> chapters = state.chapters;
        chapters.removeAt(readChapter.chapter.index);
        chapters.insert(readChapter.chapter.index, readChapter.chapter);
        emit(state.copyWith(readChapter: readChapter));
      }
    } catch (error) {
      _logger.log(error, name: "getChapterContent");
      emit(state.copyWith(
          readChapter: readChapter.copyWith(status: StatusType.error)));
    }
  }

  void calculateChapter() {
    ReadChapter readChapter = state.readChapter!;
    if (readChapter.chapter.index == 0) {
      previousChapter = null;
    } else {
      previousChapter = state.chapters[readChapter.chapter.index - 1];
    }
    if (readChapter.chapter.index == state.chapters.length - 1) {
      nextChapter = null;
    } else {
      nextChapter = state.chapters[readChapter.chapter.index + 1];
    }
  }

  Future<void> onPreviousChapter() async {
    calculateChapter();
    if (previousChapter == null) return;
    emit(state.copyWith(
        readChapter:
            ReadChapter(chapter: previousChapter!, status: StatusType.init)));
  }

  Future<void> onNextChapter() async {
    calculateChapter();
    if (nextChapter == null) {
      if (state.menuType == MenuType.autoScroll) {
        onCloseAutoScroll();
      }
      return;
    }
    emit(state.copyWith(
        readChapter:
            ReadChapter(chapter: nextChapter!, status: StatusType.init)));
  }

  Future<void> onRefreshChapters() async {
    fToast.showToast(
      child: ToastWidget(msg: "book.start_update_chapters".tr()),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
    final lstChapter = await _jsRuntime.getChapters(
        url: book.bookUrl, jsScript: _extension!.getChaptersScript);
    if (lstChapter.length > state.chapters.length) {
      if (book.bookmark && book.id != null) {
        List<Chapter> newChapters = lstChapter
            .getRange(state.chapters.length, lstChapter.length)
            .toList();
        newChapters =
            newChapters.map((e) => e.copyWith(bookId: book.id)).toList();
        await _databaseService.insertChapters(newChapters);

        final chapters = await _databaseService.getChaptersByBookId(book.id!);
        setBook = book.copyWith(totalChapters: chapters.length);
        await _databaseService.updateBook(book);
        emit(state.copyWith(chapters: chapters));
      } else {
        final chapters = lstChapter;
        emit(state.copyWith(chapters: chapters));
      }

      final totalNewChapter = lstChapter.length - state.chapters.length;
      fToast.showToast(
        child: ToastWidget(
            msg: "book.update_new_chapters"
                .tr(args: [totalNewChapter.toString()])),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    } else {
      fToast.showToast(
        child: ToastWidget(msg: "book.update_no_new_chapters".tr()),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  void onChangeReadChapter(Chapter chapter) {
    emit(state.copyWith(
        readChapter: ReadChapter(chapter: chapter, status: StatusType.init)));
  }

  // autoScroll
  void onEnableAutoScroll() async {
    await onHideCurrentMenu();
    emit(state.copyWith(
        controlStatus: ControlStatus.init, menuType: MenuType.autoScroll));
  }

  void onCloseAutoScroll() async {
    await onHideCurrentMenu();
    emit(state.copyWith(
        controlStatus: ControlStatus.none, menuType: MenuType.base));
  }

  void onUnpauseAutoScroll() async {
    emit(state.copyWith(controlStatus: ControlStatus.start));
  }

  void onPauseAutoScroll() async {
    emit(state.copyWith(controlStatus: ControlStatus.pause));
  }

  ScrollPhysics? get getPhysicsScroll {
    if (state.menuType != MenuType.autoScroll) {
      return null;
    }
    return const NeverScrollableScrollPhysics();
  }

  void onChangeTimerAutoScroll(double value) {
    if (sliderTimeAutoScroll != null) {
      sliderTimeAutoScroll?.cancel();
    }
    sliderTimeAutoScroll = Timer(const Duration(milliseconds: 300), () {
      handlerAutoScroll?.call();
    });
    timeAutoScroll.value = value;
  }

  void onAddToBookmark() async {
    if (!book.bookmark) {
      try {
        final bookId =
            await _databaseService.onInsertBook(book.copyWith(bookmark: true));
        setBook = book.copyWith(id: bookId, bookmark: true);
        List<Chapter> chapters =
            state.chapters.map((e) => e.copyWith(bookId: bookId)).toList();
        await _databaseService.insertChapters(chapters);
        chapters = await _databaseService.getChaptersByBookId(bookId);
        emit(state.copyWith(chapters: chapters));
        fToast.showToast(
          child: ToastWidget(msg: "bookmark.add_complete".tr()),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } catch (error) {
        _logger.error(error, name: "addToBookmark");
      }
    }
  }

  void onDeleteToBookmark() async {
    if (book.bookmark) {
      try {
        await _databaseService.onDeleteBook(book.id!);
        await _databaseService.deleteChaptersByBookId(book.id!);
        setBook = book.deleteBookmark();
        fToast.showToast(
          child: ToastWidget(msg: "bookmark.delete_complete".tr()),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } catch (error) {
        _logger.error(error, name: "deleteBookmark");
      }
    }
  }

  bool get isHideAction => book.type == BookType.video;

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    SystemUtils.setPreferredOrientations();
    timeAutoScroll.dispose();
    sliderTimeAutoScroll?.cancel();
    chaptersSliderTime?.cancel();
    _menuAnimationController.dispose();
    DeviceUtils.disableWakelock();
    return super.close();
  }
}
