import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PagePlugin {
  final String title;
  final String fetch;
  final String replacePage;
  final String url;
  final String regexp;
  List<Scripts> scripts;
  PagePlugin({
    required this.title,
    required this.fetch,
    required this.replacePage,
    required this.url,
    required this.regexp,
    required this.scripts,
  });

  PagePlugin copyWith({
    String? title,
    String? fetch,
    String? replacePage,
    String? url,
    String? regexp,
    List<Scripts>? scripts,
  }) {
    return PagePlugin(
      title: title ?? this.title,
      fetch: fetch ?? this.fetch,
      replacePage: replacePage ?? this.replacePage,
      url: url ?? this.url,
      regexp: regexp ?? this.regexp,
      scripts: scripts ?? this.scripts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'fetch': fetch,
      'replacePage': replacePage,
      'url': url,
      'regexp': regexp,
      'scripts': scripts.map((x) => x.toMap()).toList(),
    };
  }

  factory PagePlugin.fromMap(Map<String, dynamic> map) {
    return PagePlugin(
      title: map['title'] ?? "",
      fetch: map['fetch'] ?? "",
      replacePage: map['replacePage'] ?? "",
      url: map['url'] ?? "",
      regexp: map['regexp'] ?? "",
      scripts: map['scripts'] != null
          ? List<Scripts>.from(
              (map['scripts']).map<Scripts>(
                (item) => Scripts.fromMap(item),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory PagePlugin.fromJson(String source) =>
      PagePlugin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PagePlugin(title: $title, fetch: $fetch, replacePage: $replacePage, url: $url, regexp: $regexp, scripts: $scripts)';
  }

  @override
  bool operator ==(covariant PagePlugin other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.fetch == fetch &&
        other.replacePage == replacePage &&
        other.url == url &&
        other.regexp == regexp &&
        listEquals(other.scripts, scripts);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        fetch.hashCode ^
        replacePage.hashCode ^
        url.hashCode ^
        regexp.hashCode ^
        scripts.hashCode;
  }
}

class Scripts {
  final String script;
  final String injectionTime;
  Scripts({
    required this.script,
    required this.injectionTime,
  });

  Scripts copyWith({
    String? script,
    String? injectionTime,
  }) {
    return Scripts(
      script: script ?? this.script,
      injectionTime: injectionTime ?? this.injectionTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'script': script,
      'injectionTime': injectionTime,
    };
  }

  factory Scripts.fromMap(Map<String, dynamic> map) {
    return Scripts(
      script: map['script'] ?? "",
      injectionTime: map['injectionTime'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Scripts.fromJson(String source) =>
      Scripts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Scripts(script: $script, injectionTime: $injectionTime)';

  @override
  bool operator ==(covariant Scripts other) {
    if (identical(this, other)) return true;

    return other.script == script && other.injectionTime == injectionTime;
  }

  @override
  int get hashCode => script.hashCode ^ injectionTime.hashCode;
}
