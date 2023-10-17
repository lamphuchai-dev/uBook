import 'package:isar/isar.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/utils/directory_utils.dart';

class DatabaseService {
  // final _logger = Logger("DatabaseService");
  late final Isar database;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    database = await Isar.open(
      [BookSchema],
      directory: _path,
    );
  }

  Future<int?> onInsertBook(Book book) async {
    return database.writeTxn(() => database.books
        .put(book.copyWith(updateAt: DateTime.now(), bookmark: true)));
  }

  Future<bool> onDeleteBook(int id) async {
    return database.writeTxn(() => database.books.delete(id));
  }

  Future<List<Book>> getBooks() {
    return database.books.where().sortByUpdateAtDesc().findAll();
  }

  Future<dynamic> updateBook(Book book) {
    return database.writeTxn(() => database.books.put(book));
  }

  Future<Book?> getBookByUrl(String bookUrl) =>
      database.books.filter().bookUrlMatches(bookUrl).findFirst();

  Stream<void> get bookStream => database.books.watchLazy();
}
