import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/data/models/metadata.dart';
import 'package:ubook/data/models/script.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

class ExtensionsService {
  final _logger = Logger('ExtensionsManager');
  List<Extension> _exts = [];
  final DioClient _dioClient = DioClient();

  List<Extension> get getExtensions => _exts;
  late final JsRuntime _runTime;

  JsRuntime get jsRuntime => _runTime;

  final StreamController<List<Extension>> _extensionStreamController =
      StreamController<List<Extension>>.broadcast();

  Stream<List<Extension>> get extensionsChange =>
      _extensionStreamController.stream;

  Future<void> onInit() async {
    _runTime = JsRuntime();
    _runTime.initRuntime();
    await loadLocalExtension();
  }

  Future<void> loadLocalExtension() async {
    final dir = await DirectoryUtils.getListFileExt();
    List<Extension> exts = [];
    for (var item in dir) {
      final extFile = File("${item.path}/extension.json");
      final ext = Extension.fromJson(extFile.readAsStringSync());
      exts.add(ext);
    }
    _logger.log("exts = ${exts.length}", name: "loadLocalExtension");
    _exts = exts;
    _extensionStreamController.add(_exts);
  }

  Future<Extension?> installExtensionByUrl(String url) async {
    try {
      final res = await _dioClient.get(url,
          options: Options(responseType: ResponseType.bytes));
      if (res is List<int>) {
        final archive = ZipDecoder().decodeBytes(res);
        final fileExt = archive.files
            .firstWhereOrNull((item) => item.name == "extension.json");
        if (fileExt != null) {
          final contentString = utf8.decode(fileExt.content as List<int>);
          Extension ext = Extension.fromJson(contentString);
          final path = await DirectoryUtils.getDirectoryExtensions;
          Script script = ext.script;
          final pathExt = "$path/${ext.metadata.slug}";
          for (final file in archive) {
            final filename = file.name;
            final pathFile = "$pathExt/$filename";
            if (file.isFile) {
              final data = file.content as List<int>;
              File(pathFile)
                ..createSync(recursive: true)
                ..writeAsBytesSync(data);
              if (ext.script.home == filename) {
                script.home = pathFile;
              } else if (ext.script.detail == filename) {
                script.detail = pathFile;
              } else if (ext.script.chapters == filename) {
                script.chapters = pathFile;
              } else if (ext.script.chapter == filename) {
                script.chapter = pathFile;
              } else if (ext.script.search == filename) {
                script.search = pathFile;
              } else if (ext.script.genre == filename) {
                script.genre = pathFile;
              }
            } else {
              Directory(pathFile).create(recursive: true);
            }
          }
          ext = ext.copyWith(
              script: script,
              metadata: ext.metadata.copyWith(localPath: pathExt));
          File("$pathExt/$fileExt")
            ..createSync(recursive: true)
            ..writeAsBytesSync(utf8.encode(ext.toJson()));
          _logger.log("install done");
          _exts.add(ext);
          _extensionStreamController.add(_exts);
          return ext;
        }
      }
    } catch (error) {
      _logger.error(error, name: "installExtensionByUrl");
    }
    return null;
  }

  Future<bool> uninstallExtension(Extension extensionModel) async {
    final dirExt =
        DirectoryUtils.getDirectoryByPath(extensionModel.metadata.localPath);
    if (dirExt.existsSync()) {
      dirExt.deleteSync(recursive: true);
      final exts = _exts
          .where(
              (item) => item.metadata.source != extensionModel.metadata.source)
          .toList();
      _exts = exts;
      _extensionStreamController.add(_exts);
      return true;
    }
    return false;
  }

  Future<List<Metadata>> getListExts() async {
    try {
      final res = await _dioClient.get(
          "https://github.com/lamphuchai-dev/book_project/raw/main/ext-book/extensions.json");
      final metadata = jsonDecode(res)
          .map<Metadata>((map) => Metadata.fromMap(map))
          .toList();
      return metadata;
    } catch (error) {
      return [];
    }
  }

  Extension? getExtensionBySource(String source) {
    return _exts.firstWhereOrNull((elm) => elm.metadata.source == source);
  }

  close() {
    _extensionStreamController.close();
  }
}
