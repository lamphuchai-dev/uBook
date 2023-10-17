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
  @Index()
  final String host;
  final int totalChapters;
  @Enumerated(EnumType.ordinal)
  final BookType type;
  final bool bookmark;
  final int? currentReadChapter;
  final DateTime? updateAt;
  @ignore
  final List<Genre> genres;

  const Book(
      {this.id,
      required this.name,
      required this.bookUrl,
      required this.author,
      required this.bookStatus,
      required this.description,
      required this.cover,
      required this.host,
      required this.totalChapters,
      required this.type,
      required this.bookmark,
      this.currentReadChapter,
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
      int? currentReadChapter,
      DateTime? updateAt,
      List<Genre>? genres}) {
    return Book(
        id: id ?? this.id,
        name: name ?? this.name,
        bookUrl: bookUrl ?? this.bookUrl,
        author: author ?? this.author,
        bookStatus: bookStatus ?? this.bookStatus,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        host: host ?? this.host,
        totalChapters: totalChapters ?? this.totalChapters,
        type: type ?? this.type,
        genres: genres ?? this.genres,
        bookmark: bookmark ?? this.bookmark,
        currentReadChapter: currentReadChapter ?? this.currentReadChapter,
        updateAt: updateAt ?? this.updateAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bookUrl': bookUrl,
      'author': author,
      'description': description,
      'cover': cover,
      'host': host,
      'totalChapters': totalChapters,
      'type': type.name,
      "genres": genres.map((e) => e.toMap())
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        host: map['host'] ?? "",
        totalChapters: map['totalChapters'] ?? 0,
        bookStatus: map["bookStatus"] ?? "",
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
        currentReadChapter: map["currentReadChapter"],
        updateAt: map["updateAt"]);
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
    return 'Book(id: $id, name: $name, bookUrl: $bookUrl, author: $author, description: $description, cover: $cover, host: $host, totalChapters: $totalChapters, type: $type, bookmark: $bookmark, currentReadChapter: $currentReadChapter, updateAt: $updateAt)';
  }

  String getSourceByBookUrl() {
    final uri = Uri.parse(bookUrl);
    return "${uri.scheme}://${uri.host}";
  }
}
