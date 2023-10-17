// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ubook/app/config/app_type.dart';

class Metadata {
  String name;
  String author;
  String slug;
  int version;
  String source;
  String regexp;
  String description;
  String locale;
  String language;
  ExtensionType type;
  String path;
  String localPath;

  List<TabsHome> tabsHome;
  Metadata({
    required this.name,
    required this.author,
    required this.slug,
    required this.version,
    required this.source,
    required this.regexp,
    required this.description,
    required this.locale,
    required this.language,
    required this.type,
    required this.path,
    required this.localPath,
    required this.tabsHome,
  });

  Metadata copyWith({
    String? name,
    String? author,
    String? slug,
    int? version,
    String? source,
    String? regexp,
    String? description,
    String? locale,
    String? language,
    ExtensionType? type,
    String? path,
    String? localPath,
    List<TabsHome>? tabsHome,
  }) {
    return Metadata(
      name: name ?? this.name,
      author: author ?? this.author,
      slug: slug ?? this.slug,
      version: version ?? this.version,
      source: source ?? this.source,
      regexp: regexp ?? this.regexp,
      description: description ?? this.description,
      locale: locale ?? this.locale,
      language: language ?? this.language,
      type: type ?? this.type,
      path: path ?? this.path,
      localPath: localPath ?? this.localPath,
      tabsHome: tabsHome ?? this.tabsHome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'slug': slug,
      'version': version,
      'source': source,
      'regexp': regexp,
      'description': description,
      'locale': locale,
      'language': language,
      'type': type.name,
      'path': path,
      'localPath': localPath,
      'tabsHome': tabsHome.map((x) => x.toMap()).toList(),
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      name: map['name'] as String,
      author: map['author'] as String,
      slug: map['slug'] as String,
      version: map['version'] as int,
      source: map['source'] as String,
      regexp: map['regexp'] as String,
      description: map['description'] as String,
      locale: map['locale'] as String,
      language: map['language'] as String,
      type: ExtensionType.values.firstWhere(
        (type) => type.name == map["type"],
        orElse: () => ExtensionType.novel,
      ),
      path: map['path'] ?? "",
      localPath: map['localPath'] ?? "",
      tabsHome: map['tabsHome'] != null
          ? List<TabsHome>.from(
              (map['tabsHome']).map<TabsHome>(
                (x) => TabsHome.fromMap(x),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Metadata.fromJson(String source) =>
      Metadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Metadata(name: $name, author: $author, slug: $slug, version: $version, source: $source, regexp: $regexp, description: $description, locale: $locale, language: $language, type: $type, path: $path, localPath: $localPath, tabsHome: $tabsHome)';
  }

  @override
  bool operator ==(covariant Metadata other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.author == author &&
        other.slug == slug &&
        other.version == version &&
        other.source == source &&
        other.regexp == regexp &&
        other.description == description &&
        other.locale == locale &&
        other.language == language &&
        other.type == type &&
        other.path == path &&
        other.localPath == localPath &&
        listEquals(other.tabsHome, tabsHome);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        author.hashCode ^
        slug.hashCode ^
        version.hashCode ^
        source.hashCode ^
        regexp.hashCode ^
        description.hashCode ^
        locale.hashCode ^
        language.hashCode ^
        type.hashCode ^
        path.hashCode ^
        localPath.hashCode ^
        tabsHome.hashCode;
  }
}

class TabsHome {
  String title;
  String url;
  TabsHome({
    required this.title,
    required this.url,
  });

  TabsHome copyWith({
    String? title,
    String? url,
  }) {
    return TabsHome(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory TabsHome.fromMap(Map<String, dynamic> map) {
    return TabsHome(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TabsHome.fromJson(String source) =>
      TabsHome.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TabsHome(title: $title, url: $url)';

  @override
  bool operator ==(covariant TabsHome other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
