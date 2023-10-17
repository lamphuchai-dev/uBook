// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_book_cubit.dart';

abstract class ReadBookState extends Equatable {
  const ReadBookState({required this.totalChapters});
  final int totalChapters;

  @override
  List<Object> get props => [totalChapters];
}

class ReadBookInitial extends ReadBookState {
  const ReadBookInitial(
      {required super.totalChapters, required this.extensionStatus});
  final ExtensionStatus extensionStatus;

  ReadBookInitial copyWith({
    ExtensionStatus? extensionStatus,
  }) {
    return ReadBookInitial(
        extensionStatus: extensionStatus ?? this.extensionStatus,
        totalChapters: totalChapters);
  }
}

class BaseReadBook extends ReadBookState {
  const BaseReadBook({required super.totalChapters});

  BaseReadBook copyWith({int? totalChapters}) {
    return BaseReadBook(totalChapters: totalChapters ?? this.totalChapters);
  }

  @override
  List<Object> get props => [totalChapters];
}

class AutoScrollReadBook extends ReadBookState {
  const AutoScrollReadBook({
    required super.totalChapters,
    required this.timerScroll,
    required this.scrollStatus,
  });
  final double timerScroll;
  final AutoScrollStatus scrollStatus;

  AutoScrollReadBook copyWith(
      {double? timerScroll,
      int? totalChapters,
      AutoScrollStatus? scrollStatus,
      bool? isShowMenu}) {
    return AutoScrollReadBook(
        totalChapters: totalChapters ?? this.totalChapters,
        timerScroll: timerScroll ?? this.timerScroll,
        scrollStatus: scrollStatus ?? this.scrollStatus);
  }

  @override
  List<Object> get props => [totalChapters, timerScroll, scrollStatus];
}
