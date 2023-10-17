import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/data/models/genre.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/services/storage_service.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
      {required StorageService storageService, required this.extensionManager})
      : _storageService = storageService,
        _jsRuntime = extensionManager.jsRuntime,
        super(HomeStateInitial()) {
    _streamSubscription =
        extensionManager.extensionsChange.listen((exts) async {
      final state = this.state;

      if (state is LoadedExtensionState) {
        final ext =
            extensionManager.getExtensionBySource(state.extension.source);
        if (ext != null) return;
        final exts = extensionManager.getExtensions;
        if (exts.isEmpty) {
          emit(ExtensionNoInstallState());
        } else {
          emit(LoadedExtensionState(extension: exts.first));
        }
      } else if (state is ExtensionNoInstallState) {
        final exts = extensionManager.getExtensions;
        if (exts.isEmpty) {
          emit(ExtensionNoInstallState());
        } else {
          emit(LoadedExtensionState(extension: exts.first));
        }
      }
    });
  }
  final _logger = Logger("HomeCubit");

  late StreamSubscription _streamSubscription;
  final StorageService _storageService;
  final ExtensionsService extensionManager;
  final JsRuntime _jsRuntime;

  void onInit() async {
    try {
      emit(LoadingExtensionState());

      final exts = extensionManager.getExtensions;
      if (exts.isEmpty) {
        emit(ExtensionNoInstallState());
        return;
      }
      String? sourceExtPrimary =
          await _storageService.getSourceExtensionPrimary();
      sourceExtPrimary ??= exts.first.source;
      final extRuntime =
          extensionManager.getExtensionBySource(sourceExtPrimary);
      if (extRuntime == null) {
        await _storageService.setSourceExtensionPrimary(exts.first.source);
        emit(LoadedExtensionState(extension: exts.first));
      } else {
        emit(LoadedExtensionState(extension: extRuntime));
      }
    } catch (error) {
      _logger.error(error);
      emit(ExtensionNoInstallState());
    }
  }

  Future<List<Book>> onGetListBook(String url, int page) async {
    final state = this.state;
    if (state is! LoadedExtensionState) return [];

    try {
      url = "${state.extension.source}$url";
      final jsScript =
          DirectoryUtils.getJsScriptByPath(state.extension.script.home);
      final result = await _jsRuntime.listBook(
          url: url,
          page: page,
          jsScript: jsScript,
          extType: state.extension.metadata.type);
      return result;
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  Future<List<Genre>> onGetListGenre() async {
    final state = this.state;
    if (state is! LoadedExtensionState) return [];

    try {
      final jsScript =
          DirectoryUtils.getJsScriptByPath(state.extension.script.genre!);
      final result = await _jsRuntime.genre(
          url: state.extension.source, jsScript: jsScript);
      return result;
    } catch (error) {
      _logger.error(error, name: "onGetListGenre");
    }
    return [];
  }

  Future<List<Book>> onSearchBook(String keyWord, int page) async {
    try {
      final state = this.state;
      if (state is! LoadedExtensionState) return [];
      return await _jsRuntime.search(
          url: state.extension.source,
          keyWord: keyWord,
          page: page,
          extType: state.extension.metadata.type,
          jsScript:
              DirectoryUtils.getJsScriptByPath(state.extension.script.search!));
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  void onChangeExtensions(Extension extension) async {
    final state = this.state;
    if (state is! LoadedExtensionState) return;
    emit(LoadingExtensionState());
    await Future.delayed(const Duration(milliseconds: 50));
    await _storageService.setSourceExtensionPrimary(extension.source);
    emit(LoadedExtensionState(extension: extension));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
