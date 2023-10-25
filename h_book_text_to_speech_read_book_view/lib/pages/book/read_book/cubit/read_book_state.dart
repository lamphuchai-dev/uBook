// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_book_cubit.dart';

abstract class ReadBookState extends Equatable {
  const ReadBookState({required this.chapters});
  final List<Chapter> chapters;

  @override
  List<Object> get props => [chapters];
}

class ReadBookInitial extends ReadBookState {
  const ReadBookInitial({required super.chapters});
}

class ReadBookBase extends ReadBookState {
  const ReadBookBase({required super.chapters});

  ReadBookBase copyWith({List<Chapter>? chapters}) {
    return ReadBookBase(chapters: chapters ?? this.chapters);
  }

  @override
  List<Object> get props => [chapters];
}

class ReadBookAutoScroll extends ReadBookState {
  const ReadBookAutoScroll({
    required super.chapters,
    required this.timerScroll,
    required this.scrollStatus,
  });
  final double timerScroll;
  final AutoScrollStatus scrollStatus;

  ReadBookAutoScroll copyWith(
      {double? timerScroll,
      List<Chapter>? chapters,
      AutoScrollStatus? scrollStatus,
      bool? isShowMenu}) {
    return ReadBookAutoScroll(
        chapters: chapters ?? this.chapters,
        timerScroll: timerScroll ?? this.timerScroll,
        scrollStatus: scrollStatus ?? this.scrollStatus);
  }

  @override
  List<Object> get props => [chapters, timerScroll, scrollStatus];
}

class ReadBookMedia extends ReadBookState {
  const ReadBookMedia({
    required super.chapters,
    required this.mediaStatus,
    required this.textSpeak,
    required this.chapter,
  });
  final MediaStatus mediaStatus;
  final String textSpeak;
  final Chapter chapter;

  ReadBookMedia copyWith(
      {MediaStatus? mediaStatus,
      String? textSpeak,
      List<Chapter>? chapters,
      Chapter? chapter,
      bool? isShowMenu}) {
    return ReadBookMedia(
        mediaStatus: mediaStatus ?? this.mediaStatus,
        textSpeak: textSpeak ?? this.textSpeak,
        chapters: chapters ?? this.chapters,
        chapter: chapter ?? this.chapter);
  }

  @override
  List<Object> get props => [chapters, mediaStatus, textSpeak, chapter];
}
