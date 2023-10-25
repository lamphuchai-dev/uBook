import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InfoPlugin {
  final String name;
  final String author;
  final int version;
  final String source;
  final String regexp;
  final String description;
  final String locale;
  InfoPlugin({
    required this.name,
    required this.author,
    required this.version,
    required this.source,
    required this.regexp,
    required this.description,
    required this.locale,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'version': version,
      'source': source,
      'regexp': regexp,
      'description': description,
      'locale': locale,
    };
  }

  factory InfoPlugin.fromMap(Map<String, dynamic> map) {
    return InfoPlugin(
      name: map['name'] as String,
      author: map['author'] as String,
      version: map['version'] as int,
      source: map['source'] as String,
      regexp: map['regexp'] as String,
      description: map['description'] as String,
      locale: map['locale'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoPlugin.fromJson(String source) =>
      InfoPlugin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InfoPlugin(name: $name, author: $author, version: $version, source: $source, regexp: $regexp, description: $description, locale: $locale)';
  }

  InfoPlugin copyWith({
    String? name,
    String? author,
    int? version,
    String? source,
    String? regexp,
    String? description,
    String? locale,
  }) {
    return InfoPlugin(
      name: name ?? this.name,
      author: author ?? this.author,
      version: version ?? this.version,
      source: source ?? this.source,
      regexp: regexp ?? this.regexp,
      description: description ?? this.description,
      locale: locale ?? this.locale,
    );
  }
}
