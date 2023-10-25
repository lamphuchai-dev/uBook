// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:h_book/data/models/page_plugin.dart';

import 'plugin_info.dart';

class BookPlugin {
  final InfoPlugin info;
  final List<PagePlugin> homeTabs;
  final List<PagePlugin> pages;
  BookPlugin({
    required this.info,
    required this.homeTabs,
    required this.pages,
  });

  BookPlugin copyWith({
    InfoPlugin? info,
    List<PagePlugin>? homeTabs,
    List<PagePlugin>? pages,
  }) {
    return BookPlugin(
      info: info ?? this.info,
      homeTabs: homeTabs ?? this.homeTabs,
      pages: pages ?? this.pages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'info': info.toMap(),
      'homeTabs': homeTabs.map((x) => x.toMap()).toList(),
      'pages': pages.map((x) => x.toMap()).toList(),
    };
  }

  factory BookPlugin.fromMap(Map<String, dynamic> map) {
    return BookPlugin(
      info: InfoPlugin.fromMap(map['info']),
      homeTabs: List<PagePlugin>.from(
        (map['homeTabs']).map<PagePlugin>(
          (x) => PagePlugin.fromMap(x),
        ),
      ),
      pages: List<PagePlugin>.from(
        (map['pages']).map<PagePlugin>(
          (x) => PagePlugin.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookPlugin.fromJson(String source) =>
      BookPlugin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BookPlugin(info: $info, homeTabs: $homeTabs, pages: $pages)';

  @override
  bool operator ==(covariant BookPlugin other) {
    if (identical(this, other)) return true;

    return other.info == info &&
        listEquals(other.homeTabs, homeTabs) &&
        listEquals(other.pages, pages);
  }

  @override
  int get hashCode => info.hashCode ^ homeTabs.hashCode ^ pages.hashCode;
}
