// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class BookDirectory {
  static Future<String> get getDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return _bookDir(directory);
  }

  static Future<String> get getCacheDirectory async {
    final directory = await getTemporaryDirectory();
    return _bookDir(directory);
  }

  static String _bookDir(Directory directory) {
    final dir = path.join(directory.path, 'book');
    Directory(dir).createSync(recursive: true);
    return dir;
  }
}
