import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chapter extends Equatable {
  final String id;
  final String bookId;
  final String name;
  final String slug;
  final int index;
  final String publishedAt;
  final String content;
  const Chapter({
    required this.id,
    required this.bookId,
    required this.name,
    required this.slug,
    required this.index,
    required this.publishedAt,
    required this.content,
  });

  Chapter copyWith({
    String? id,
    String? bookId,
    String? name,
    String? slug,
    int? index,
    String? publishedAt,
    String? content,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      index: index ?? this.index,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'name': name,
      'slug': slug,
      'index': index,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] ?? "",
      bookId: map['bookId'] ?? "",
      name: map['name'] ?? "",
      slug: map['slug'] ?? "",
      index: map['index'] ?? 0,
      publishedAt: map['publishedAt'] ?? "",
      content: map['content'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      bookId,
      name,
      slug,
      index,
      publishedAt,
      content,
    ];
  }
}
