import 'book.dart';
import 'chapter.dart';

class ChaptersPageArgs {
  final Book book;
  final List<Chapter> chapters;
  ChaptersPageArgs({
    required this.book,
    this.chapters = const [],
  });
}
