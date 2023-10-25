import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:h_book/data/models/chapter.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Book extends Equatable {
  final String name;
  final String link;
  final String authorName;
  final String description;
  final String poster;
  final String host;
  final int chapterCount;
  final List<Chapter> chapters;
  final int readChapterIndex;
  const Book(
      {required this.name,
      required this.link,
      required this.authorName,
      required this.description,
      required this.poster,
      required this.host,
      required this.chapterCount,
      required this.chapters,
      required this.readChapterIndex});

  Book copyWith(
      {String? name,
      String? link,
      String? authorName,
      String? description,
      String? poster,
      String? host,
      int? chapterCount,
      List<Chapter>? chapters,
      int? readChapterIndex}) {
    return Book(
        name: name ?? this.name,
        link: link ?? this.link,
        authorName: authorName ?? this.authorName,
        description: description ?? this.description,
        poster: poster ?? this.poster,
        host: host ?? this.host,
        chapterCount: chapterCount ?? this.chapterCount,
        chapters: chapters ?? this.chapters,
        readChapterIndex: readChapterIndex ?? this.readChapterIndex);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
      'authorName': authorName,
      'description': description,
      'poster': poster,
      'host': host,
      'chapterCount': chapterCount,
      'chapters': chapters.map((x) => x.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      name: map['name'] ?? "",
      link: map['link'] ?? "",
      authorName: map['author_name'] ?? "",
      description: map['description'] ?? "",
      poster: map['poster'] ?? "",
      host: map['host'] ?? "",
      chapterCount: map['chapter_count'] ?? 0,
      readChapterIndex: map['read_chapter_index'] ?? 0,
      chapters: map['chapters'] == null
          ? []
          : List<Chapter>.from(
              (map['chapters']).map<Chapter>(
                (x) => Chapter.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      link,
      authorName,
      description,
      poster,
      host,
      chapterCount,
      chapters,
    ];
  }
}
