// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_book_cubit.dart';

enum ExtensionStatus { init, ready, noInstall }

enum ControlStatus { none, init, start, pause, complete, stop, error }

enum MenuType { base, media, autoScroll }

class ReadBookState extends Equatable {
  const ReadBookState(
      {required this.chapters,
      required this.statusType,
      required this.extensionStatus,
      required this.controlStatus,
      required this.menuType,
      required this.book,
      this.readChapter});
  final List<Chapter> chapters;
  final StatusType statusType;
  final ExtensionStatus extensionStatus;
  final ReadChapter? readChapter;
  final ControlStatus controlStatus;
  final MenuType menuType;
  final Book book;
  @override
  List<Object?> get props => [
        chapters,
        statusType,
        extensionStatus,
        readChapter,
        menuType,
        controlStatus,
        book
      ];

  ReadBookState copyWith(
      {List<Chapter>? chapters,
      StatusType? statusType,
      ExtensionStatus? extensionStatus,
      ReadChapter? readChapter,
      ControlStatus? controlStatus,
      MenuType? menuType,
      Book? book}) {
    return ReadBookState(
        book: book ?? this.book,
        chapters: chapters ?? this.chapters,
        statusType: statusType ?? this.statusType,
        extensionStatus: extensionStatus ?? this.extensionStatus,
        readChapter: readChapter ?? this.readChapter,
        menuType: menuType ?? this.menuType,
        controlStatus: controlStatus ?? this.controlStatus);
  }
}

class ReadChapter extends Equatable {
  final Chapter chapter;
  final StatusType status;
  const ReadChapter({
    required this.chapter,
    required this.status,
  });

  ReadChapter copyWith({
    Chapter? chapter,
    StatusType? status,
  }) {
    return ReadChapter(
      chapter: chapter ?? this.chapter,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [chapter, status];
}
