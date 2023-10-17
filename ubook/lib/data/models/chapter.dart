// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';


class Chapter extends Equatable {
  final String title;
  final String url;
  final String bookUrl;
  final int index;
  final List<String> content;
  const Chapter({
    required this.title,
    required this.url,
    required this.bookUrl,
    required this.index,
    required this.content,
  });

  Chapter copyWith({
    String? title,
    String? url,
    String? bookUrl,
    int? index,
    List<String>? content,
  }) {
    return Chapter(
      title: title ?? this.title,
      url: url ?? this.url,
      bookUrl: bookUrl ?? this.bookUrl,
      index: index ?? this.index,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'bookUrl': bookUrl,
      'index': index,
      'content': content,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        title: map['title'] ?? "",
        url: map['url'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        index: map['index'] ?? 0,
        content: map['content'] != null
            ? List<String>.from(
                (map['content']),
              )
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      title,
      url,
      bookUrl,
      index,
      content,
    ];
  }
}
