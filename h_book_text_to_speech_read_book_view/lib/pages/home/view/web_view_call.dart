// ignore_for_file: public_member_api_docs, sort_constructors_first
class WebViewCall {
  final String url;
  final String regexpApi;
  final String replaceValue;
  final String userScript;
  WebViewCall(
      {required this.url,
      required this.regexpApi,
      required this.replaceValue,
      required this.userScript});
}

class HeadlessConfig {
  final String title;
  final String url;
  final String regexpApi;
  final String replaceValue;
  final String userScript;
  HeadlessConfig(
      {required this.title,
      required this.url,
      required this.regexpApi,
      required this.replaceValue,
      required this.userScript});

  HeadlessConfig copyWith({
    String? title,
    String? url,
    String? regexpApi,
    String? replaceValue,
    String? userScript,
  }) {
    return HeadlessConfig(
      title: title ?? this.title,
      url: url ?? this.url,
      regexpApi: regexpApi ?? this.regexpApi,
      replaceValue: replaceValue ?? this.replaceValue,
      userScript: userScript ?? this.userScript,
    );
  }
}
