import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/data/models/book.dart';
import 'package:h_book/data/models/chapter.dart';
import 'package:h_book/services/text_to_speech_service.dart';
import 'package:h_book/utils/logger.dart';

part 'read_book_state.dart';

class ReadBookCubit extends Cubit<ReadBookState> {
  final _logger = Logger("ReadBookCubit");

  ReadBookCubit(
      {required Book book, required TextToSpeechService textToSpeechService})
      : _book = book,
        _textToSpeechService = textToSpeechService,
        super(ReadBookBase(chapters: book.chapters));
  final Book _book;

  late final PageController pageController;
  late final AnimationController _menuAnimationController;
  // late final MediaService _textToSpeechService;

  final TextToSpeechService _textToSpeechService;

  int indexPageChapter = 0;
  int? indexTextSpeakChapter;
  bool _currentOnTouchScreen = false;

  ValueNotifier<int> chaptersSlider = ValueNotifier(0);

  void onInit() {
    pageController = PageController();
    // _textToSpeechService = MediaService(chapters: _book.chapters);
    _textToSpeechService.onInit();
    _textToSpeechService.setChapters = state.chapters;
    _textToSpeechService.onStartChapter = (value) {
      final state = this.state;
      if (state is! ReadBookMedia) return;
      emit(state.copyWith(mediaStatus: MediaStatus.start, chapter: value));
      _logger.log("onStartChapter mediaStatus :: ${state.mediaStatus}");
      _logger.log("onStartChapter chapter :: ${state.chapter.index}");
    };
    _textToSpeechService.onCompleteChapter = (value) {
      final state = this.state;
      if (state is! ReadBookMedia) return;
      emit(state.copyWith(mediaStatus: MediaStatus.complete));

      _logger.log("onCompleteChapter mediaStatus :: ${state.mediaStatus}");
    };
    _textToSpeechService.onNextChapter = (value) async {
      _logger.log("onNextChapter :: ${value.index}");
      pageController.jumpToPage(indexPageChapter + 1);
      final state = this.state;
      if (state is ReadBookMedia) {
        emit(state.copyWith(mediaStatus: MediaStatus.init, chapter: value));
      }
      return true;
    };

    _textToSpeechService.onPreviousChapter = (value) async {
      _logger.log("onPreviousChapter :: ${value.index}");
      pageController.jumpToPage(indexPageChapter - 1);
      final state = this.state;
      if (state is ReadBookMedia) {
        emit(state.copyWith(mediaStatus: MediaStatus.init, chapter: value));
      }
      return true;
    };
    _textToSpeechService.onReadDoneChapters = () {
      _logger.log("onReadDoneChapters");
      emit(ReadBookInitial(chapters: state.chapters));
    };

    _textToSpeechService.mediaStatusChange.listen((event) {
      final state = this.state;
      if (state is! ReadBookMedia || state.mediaStatus == event) return;
      emit(state.copyWith(mediaStatus: event));
      _logger.log("mediaStatusChange mediaStatus init :: $event");
    });
    _textToSpeechService.progressMedia.listen((event) {
      final state = this.state;
      // print(event.text);
      if (state is! ReadBookMedia || state.textSpeak == event.text) return;
      emit(state.copyWith(textSpeak: event.text));
    });
  }

  int get getTotalChapters => _book.chapterCount;

  void onChangeChaptersSlider(int value) {
    chaptersSlider.value = value;
  }

  void setMenuAnimationController(AnimationController animationController) {
    _menuAnimationController = animationController;
  }

  // onTap vào màn hình để mở panel theo [ReadBookType]
  void onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  bool get _isShowMenu =>
      _menuAnimationController.status == AnimationStatus.completed;

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

  Future<void> onShowMenu() async {
    await _menuAnimationController.forward();
  }

  void onPageChanged(int index) {
    indexPageChapter = index;
    _logger.log("onPageChanged :: $index");
  }

  void onEnableMedia() async {
    await onHideCurrentMenu();
    await Future.delayed(const Duration(milliseconds: 20));

    emit(ReadBookMedia(
      chapters: state.chapters,
      mediaStatus: MediaStatus.init,
      chapter: state.chapters[indexPageChapter],
      textSpeak: "",
    ));
    indexTextSpeakChapter = null;
    await onShowMenu();
  }

  void onPauseMedia() {
    _textToSpeechService.onPause();
  }

  void onPlayMedia() {
    _textToSpeechService.onPlay();
  }

  void onStopMedia() async {
    final state = this.state;
    _textToSpeechService.onStop();
    await onHideCurrentMenu();
    emit(ReadBookBase(chapters: state.chapters));
  }

  void setIndexTextSpeak(int value) {
    if (indexTextSpeakChapter != null) return;
    indexTextSpeakChapter = value;
    _textToSpeechService.onStart(indexPageChapter,
        indexText: indexTextSpeakChapter);
  }

  void onSkipNextMedia() {
    _textToSpeechService.onSkipNext();
  }

  void onSkipPreviousMedia() {
    _textToSpeechService.onSkipPrevious();
  }

  void onFastForwardMedia() {
    _textToSpeechService.onFastForwardMedia();
  }

  void onFastRewindMedia() {
    _textToSpeechService.onFastRewindMedia();
  }

  void onEnableAutoScroll() async {
    await onHideCurrentMenu();
    emit(ReadBookAutoScroll(
      chapters: state.chapters,
      timerScroll: 10,
      scrollStatus: AutoScrollStatus.start,
    ));
  }

  void onCloseAutoScroll() async {
    final state = this.state;
    if (state is ReadBookAutoScroll) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.stop));
    }
    await onHideCurrentMenu();
    emit(ReadBookBase(chapters: state.chapters));
  }

  void onChangeTimerScroll(double value) {
    final state = this.state;
    if (state is ReadBookAutoScroll) {
      emit(state.copyWith(timerScroll: value));
    }
  }

  void onPauseAutoScroll() {
    final state = this.state;
    if (state is ReadBookAutoScroll) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.pause));
    }
  }

  void onPlayAutoScroll() {
    final state = this.state;
    if (state is ReadBookAutoScroll) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.start));
    }
  }

  void onAutoScrollNexPage() {
    if (indexPageChapter + 1 < state.chapters.length) {
      pageController.jumpToPage(indexPageChapter + 1);
    } else {
      onCloseAutoScroll();
    }
  }

  void onNextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void onPreviousPage() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  ScrollPhysics? getPhysicsScroll() {
    if (state is ReadBookBase || state is ReadBookInitial) return null;
    return const NeverScrollableScrollPhysics();
  }
}
