// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bookmarks_cubit.dart';

class BookmarksState extends Equatable {
  const BookmarksState({required this.books, required this.statusType});
  final StatusType statusType;
  final List<Book> books;
  @override
  List<Object> get props => [books, statusType];

  BookmarksState copyWith({
    StatusType? statusType,
    List<Book>? books,
  }) {
    return BookmarksState(
      statusType: statusType ?? this.statusType,
      books: books ?? this.books,
    );
  }
}
