import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/data/models/genre.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/services/storage_service.dart';
import 'package:ubook/utils/logger.dart';

part 'discovery_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit(
      {required StorageService storageService,
      required this.extensionManager,
      required JsRuntime jsRuntime})
      : _storageService = storageService,
        _jsRuntime = jsRuntime,
        super(DiscoveryStateInitial()) {
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
  final _logger = Logger("DiscoveryCubit");

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
      final result = await _jsRuntime.listBook(
          url: url,
          page: page,
          jsScript: state.extension.getHomeScript,
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
      final result = await _jsRuntime.genre(
          url: state.extension.source,
          jsScript: state.extension.getGenreScript);
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
          jsScript: state.extension.getSearchScript);
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
