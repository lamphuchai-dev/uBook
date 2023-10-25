import 'package:flutter/foundation.dart';
import 'dart:developer' as dev show log;

class Logger {
  final String? _tag;
  Logger(this._tag);

  void log(dynamic value) {
    if (kDebugMode) {
      dev.log(value.toString(), name: _tag ?? "");
    }
  }

  void info(dynamic value) {
    if (kDebugMode) {
      debugPrint('${_tag != null ? "[$_tag]" : ""} :: ${value.toString()}');
    }
  }

  void error(dynamic value) {
    if (kDebugMode) {
      dev.log(value.toString(), name: "${_tag ?? ""} :: ERROR");
    }
  }
}



  // void log({String? tag}) => dev.log(toString(), name: tag ?? "");
  // void print({String? tag}) => debugPrint('${tag != null ? [tag] : ""}$this');



