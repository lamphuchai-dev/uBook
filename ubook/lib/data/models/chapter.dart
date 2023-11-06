// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:ubook/data/models/book.dart';

part 'chapter.g.dart';

@Collection()
class Chapter {
  final Id? id;
  final int? bookId;
  final String title;
  final String url;
  final String bookUrl;
  final int index;
  final List<String> content;

  @ignore
  final List<Map<String, dynamic>>? contentVideo;
  @ignore
  final List<Book>? recommended;

  const Chapter({
    this.id,
    this.bookId,
    required this.title,
    required this.url,
    required this.bookUrl,
    required this.index,
    required this.content,
    this.contentVideo,
    this.recommended,
  });

  Chapter copyWith(
      {Id? id,
      int? bookId,
      String? title,
      String? url,
      String? bookUrl,
      int? index,
      List<String>? content,
      List<Map<String, dynamic>>? contentVideo,
      List<Book>? recommended}) {
    return Chapter(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        title: title ?? this.title,
        url: url ?? this.url,
        bookUrl: bookUrl ?? this.bookUrl,
        index: index ?? this.index,
        content: content ?? this.content,
        contentVideo: contentVideo ?? this.contentVideo,
        recommended: recommended ?? this.recommended);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'title': title,
      'url': url,
      'bookUrl': bookUrl,
      'index': index,
      'content': content,
      'recommended': recommended
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        id: map['id'],
        bookId: map["bookId"],
        title: map['title'] ?? "",
        url: map['url'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        index: map['index'] ?? 0,
        content: map['content'] != null
            ? List<String>.from(
                (map['content']),
              )
            : [],
        contentVideo: map['contentVideo'] != null
            ? List<Map<String, dynamic>>.from(
                (map['contentVideo']),
              )
            : [],
        recommended: map['recommended'] != null
            ? List<Book>.from(
                map["recommended"].map<Book>((item) => Book.fromMap(map)))
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bookId == bookId &&
        other.title == title &&
        other.url == url &&
        other.bookUrl == bookUrl &&
        other.index == index &&
        listEquals(other.content, content);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookId.hashCode ^
        title.hashCode ^
        url.hashCode ^
        bookUrl.hashCode ^
        index.hashCode ^
        content.hashCode;
  }
}
