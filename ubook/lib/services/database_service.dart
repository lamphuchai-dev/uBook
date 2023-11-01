import 'package:isar/isar.dart';
import 'package:ubook/data/models/download_task.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/utils/directory_utils.dart';

class DatabaseService {
  // final _logger = Logger("DatabaseService");
  late final Isar database;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    database = await Isar.open(
      [BookSchema, ChapterSchema, DownloadTaskSchema],
      directory: _path,
    );
  }

  Future<int?> onInsertChapter(Chapter chapter) async {
    return database.writeTxn(() => database.chapters.put(chapter));
  }

  Future<Book?> onGetBookById(int bookId) async {
    return database.writeTxn(() => database.books.get(bookId));
  }

  Future<List<Chapter>> getChaptersByBookId(int bookId) {
    return database.chapters.filter().bookIdEqualTo(bookId).findAll();
  }

  Future<int> onInsertBook(Book book) async {
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
    return database.writeTxn(
        () => database.books.put(book.copyWith(updateAt: DateTime.now())));
  }

  Future<Book?> getBookByUrl(String bookUrl) =>
      database.books.filter().bookUrlMatches(bookUrl).findFirst();

  Stream<void> get bookStream => database.books.watchLazy();

  Future<List<int>> insertChapters(List<Chapter> chapters) {
    return database.writeTxn(() => database.chapters.putAll(chapters));
  }

  Future<int> deleteChaptersByBookId(int bookId) {
    return database.writeTxn(
        () => database.chapters.filter().bookIdEqualTo(bookId).deleteAll());
  }

  Future<List<Chapter>> getChaptersDownload(int bookId) {
    return database.chapters
        .filter()
        .bookIdEqualTo(bookId)
        .contentIsEmpty()
        .findAll();
  }

  Future<int> onInsertDownload(DownloadTask downloadTask) async {
    return database.writeTxn(() => database.downloadTasks.put(downloadTask));
  }

  Future<int> onUpdateDownload(DownloadTask downloadTask) async {
    return database.writeTxn(() => database.downloadTasks.put(downloadTask));
  }

  Future<DownloadTask?> onGetDownloadByBookId(int bookId) async {
    return database.writeTxn(() =>
        database.downloadTasks.filter().bookIdEqualTo(bookId).findFirst());
  }

  Future<DownloadTask?> onGetDownloadTask() async {
    return database.writeTxn(() => database.downloadTasks
        .filter()
        .statusLessThan(DownloadStatus.complete)
        .statusLessThan(DownloadStatus.cannel)
        .findFirst());
  }
}
