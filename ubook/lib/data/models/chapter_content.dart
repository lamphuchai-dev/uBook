// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// class ChapterContent {
//   final String host;
//   final List<ComicContent> comic;
//   final List<String> novel;
// }

class ComicContent {
  final String url;
  final String otherUrl;
  ComicContent({
    required this.url,
    required this.otherUrl,
  });

  ComicContent copyWith({
    String? url,
    String? otherUrl,
  }) {
    return ComicContent(
      url: url ?? this.url,
      otherUrl: otherUrl ?? this.otherUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'otherUrl': otherUrl,
    };
  }

  factory ComicContent.fromMap(Map<String, dynamic> map) {
    return ComicContent(
      url: map['url'] ?? "",
      otherUrl: map['otherUrl'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ComicContent.fromJson(String source) =>
      ComicContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ComicContent(url: $url, otherUrl: $otherUrl)';

  @override
  bool operator ==(covariant ComicContent other) {
    if (identical(this, other)) return true;

    return other.url == url && other.otherUrl == otherUrl;
  }

  @override
  int get hashCode => url.hashCode ^ otherUrl.hashCode;
}
