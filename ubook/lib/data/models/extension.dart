// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ubook/data/models/script.dart';
import 'package:ubook/utils/directory_utils.dart';

import 'metadata.dart';

class Extension {
  final Metadata metadata;
  final Script script;
  Extension({
    required this.metadata,
    required this.script,
  });

  Extension copyWith({
    Metadata? metadata,
    Script? script,
  }) {
    return Extension(
      metadata: metadata ?? this.metadata,
      script: script ?? this.script,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'metadata': metadata.toMap(),
      'script': script.toMap(),
    };
  }

  factory Extension.fromMap(Map<String, dynamic> map) {
    return Extension(
      metadata: Metadata.fromMap(map['metadata'] as Map<String, dynamic>),
      script: Script.fromMap(map['script'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Extension.fromJson(String source) =>
      Extension.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Extension(metadata: $metadata, script: $script)';

  @override
  bool operator ==(covariant Extension other) {
    if (identical(this, other)) return true;

    return other.metadata == metadata && other.script == script;
  }

  @override
  int get hashCode => metadata.hashCode ^ script.hashCode;
}

extension ExtExtension on Extension {
  String get source => metadata.source;
  String get getHomeScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.home}");
  String get getDetailScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.detail}");
  String get getChaptersScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.chapters}");
  String get getChapterScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.chapter}");
  String get getGenreScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.genre}");
  String get getSearchScript =>
      DirectoryUtils.fileToString("${metadata.localPath}/${script.search}");
}
