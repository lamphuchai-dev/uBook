// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_book_cubit.dart';

class DetailBookState extends Equatable {
  const DetailBookState(
      {required this.book, required this.statusType, required this.isBookmark});
  final Book book;
  final StatusType statusType;
  final bool isBookmark;
  @override
  List<Object> get props => [book, statusType, isBookmark];

  DetailBookState copyWith({
    Book? book,
    StatusType? statusType,
    bool? isBookmark,
  }) {
    return DetailBookState(
        book: book ?? this.book,
        statusType: statusType ?? this.statusType,
        isBookmark: isBookmark ?? this.isBookmark);
  }
}
