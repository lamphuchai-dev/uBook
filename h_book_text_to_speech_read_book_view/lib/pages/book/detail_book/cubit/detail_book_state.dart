part of 'detail_book_cubit.dart';

class DetailBookState extends Equatable {
  const DetailBookState({required this.book});
  final Book book;
  @override
  List<Object> get props => [book];
}
