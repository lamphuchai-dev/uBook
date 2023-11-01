// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/genre.dart';

part 'book.g.dart';

enum BookType { novel, comic }

// flutter clean && flutter pub get && flutter pub run build_runner build
@Collection()
class Book {
  final Id? id;
  @Index()
  final String name;
  final String bookUrl;
  final String author;
  final String description;
  final String cover;
  final String bookStatus;
  final int totalChapters;
  @Enumerated(EnumType.ordinal)
  final BookType type;
  final bool bookmark;
  final DateTime? updateAt;
  final bool isDownload;
  @ignore
  final List<Genre> genres;

  final ReadBook? readBook;

  const Book(
      {this.id,
      required this.name,
      required this.isDownload,
      required this.bookUrl,
      required this.author,
      required this.bookStatus,
      required this.description,
      required this.cover,
      required this.totalChapters,
      required this.type,
      required this.bookmark,
      this.readBook,
      this.genres = const [],
      this.updateAt});

  Book copyWith(
      {Id? id,
      String? name,
      String? bookUrl,
      String? author,
      String? description,
      String? cover,
      String? host,
      String? bookStatus,
      int? totalChapters,
      BookType? type,
      bool? bookmark,
      bool? isDownload,
      int? currentReadChapter,
      DateTime? updateAt,
      List<Genre>? genres,
      ReadBook? readBook}) {
    return Book(
        id: id ?? this.id,
        name: name ?? this.name,
        bookUrl: bookUrl ?? this.bookUrl,
        isDownload: isDownload ?? this.isDownload,
        author: author ?? this.author,
        bookStatus: bookStatus ?? this.bookStatus,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        totalChapters: totalChapters ?? this.totalChapters,
        type: type ?? this.type,
        genres: genres ?? this.genres,
        bookmark: bookmark ?? this.bookmark,
        updateAt: updateAt ?? this.updateAt,
        readBook: readBook ?? this.readBook);
  }

  Book deleteBookmark() {
    return Book(
        id: null,
        name: name,
        isDownload: isDownload,
        bookUrl: bookUrl,
        author: author,
        bookStatus: bookStatus,
        description: description,
        cover: cover,
        totalChapters: totalChapters,
        type: type,
        bookmark: false);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bookUrl': bookUrl,
      'author': author,
      'description': description,
      'cover': cover,
      'totalChapters': totalChapters,
      'type': type.name,
      "genres": genres.map(
        (e) => e.toMap(),
      ),
      'readBook': readBook?.toMap()
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        totalChapters: map['totalChapters'] ?? 0,
        bookStatus: map["bookStatus"] ?? "",
        isDownload: map["isDownload"] ?? false,
        type: BookType.values.firstWhere(
          (element) => element.name == map["type"],
          orElse: () => BookType.novel,
        ),
        genres: map["genres"] != null
            ? List<Genre>.from(
                (map['genres']).map<Genre>(
                  (x) => Genre.fromMap(x),
                ),
              )
            : [],
        bookmark: map["bookmark"] ?? false,
        updateAt: map["updateAt"],
        readBook:
            map["readBook"] != null ? ReadBook.fromMap(map["readBook"]) : null);
  }

  factory Book.fromMapComic(Map<String, dynamic> map) {
    return Book.fromMap({...map, "type": "comic"});
  }

  factory Book.fromMapNovel(Map<String, dynamic> map) {
    return Book.fromMap({...map, "type": "novel"});
  }

  factory Book.fromExtensionType(
      ExtensionType extType, Map<String, dynamic> map) {
    return switch (extType) {
      ExtensionType.comic => Book.fromMapComic(map),
      ExtensionType.novel => Book.fromMapNovel(map),
    };
  }
  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, name: $name, bookUrl: $bookUrl, author: $author, description: $description, cover: $cover, bookStatus: $bookStatus, totalChapters: $totalChapters, type: $type, bookmark: $bookmark, updateAt: $updateAt, genres: $genres, readBook: $readBook)';
  }
}

extension BookExtension on Book {
  String get getPercentRead {
    final result = ((readBook?.index ?? 1) / totalChapters) * 100;
    return result.toStringAsFixed(2);
  }

  String get getSourceByBookUrl {
    final uri = Uri.parse(bookUrl);
    return "${uri.scheme}://${uri.host}";
  }
}

@embedded
class ReadBook {
  final int? index;
  final String? titleChapter;
  final String? nameExtension;
  final double? offsetLast;
  ReadBook({
    this.index,
    this.titleChapter,
    this.nameExtension,
    this.offsetLast,
  });

  ReadBook copyWith({
    int? index,
    String? titleChapter,
    String? nameExtension,
    double? offsetLast,
  }) {
    return ReadBook(
      index: index ?? this.index,
      titleChapter: titleChapter ?? this.titleChapter,
      nameExtension: nameExtension ?? this.nameExtension,
      offsetLast: offsetLast ?? this.offsetLast,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'titleChapter': titleChapter,
      'nameExtension': nameExtension,
      'offsetLast': offsetLast,
    };
  }

  factory ReadBook.fromMap(Map<String, dynamic> map) {
    return ReadBook(
      index: map['index'] != null ? map['index'] as int : null,
      titleChapter:
          map['titleChapter'] != null ? map['titleChapter'] as String : null,
      nameExtension:
          map['nameExtension'] != null ? map['nameExtension'] as String : null,
      offsetLast:
          map['offsetLast'] != null ? map['offsetLast'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadBook.fromJson(String source) =>
      ReadBook.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReadBook(index: $index, titleChapter: $titleChapter, nameExtension: $nameExtension, offsetLast: $offsetLast)';
  }

  @override
  bool operator ==(covariant ReadBook other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.titleChapter == titleChapter &&
        other.nameExtension == nameExtension &&
        other.offsetLast == offsetLast;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        titleChapter.hashCode ^
        nameExtension.hashCode ^
        offsetLast.hashCode;
  }
}
