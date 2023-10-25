import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/data/models/metadata.dart';
import 'package:ubook/services/extensions_service.dart';

part 'install_extension_state.dart';

class InstallExtensionCubit extends Cubit<InstallExtensionState> {
  InstallExtensionCubit({required ExtensionsService extensionManager})
      : _extensionManager = extensionManager,
        super(InstallExtensionState(
            installedExts: extensionManager.getExtensions,
            notInstalledExts: const [],
            statusInstalled: StatusType.loaded,
            statusAllExtension: StatusType.init));

  final ExtensionsService _extensionManager;

  bool fromToHome = false;

  void onInit() async {
    onGetListExtension();
  }

  Future<void> onGetListExtension() async {
    emit(state.copyWith(statusAllExtension: StatusType.loading));
    final list = await _extensionManager.getListExts();
    emit(state.copyWith(
        notInstalledExts: removeExtInstalled(list),
        statusAllExtension: StatusType.loaded));
  }

  Future<void> onRefreshExtensions() async {
    final list = await _extensionManager.getListExts();
    emit(state.copyWith(
      notInstalledExts: removeExtInstalled(list),
    ));
  }

  Future<bool> onInstallExt(String extUrl) async {
    final isInstallExt = await _extensionManager.installExtensionByUrl(extUrl);
    if (isInstallExt != null) {
      final exts = state.notInstalledExts;
      final noIn =
          exts.where((ext) => ext.source != isInstallExt.source).toList();
      emit(state.copyWith(
          notInstalledExts: noIn,
          installedExts: _extensionManager.getExtensions));
    }
    return isInstallExt != null;
  }

  Future<bool> onUninstallExt(Extension extension) async {
    final result = await _extensionManager.uninstallExtension(extension);
    if (result) {
      emit(state.copyWith(
          notInstalledExts: [...state.notInstalledExts, extension.metadata],
          installedExts: _extensionManager.getExtensions));
    }
    return result;
  }

  List<Metadata> getListExts() {
    List<Metadata> notInstalledExts = state.notInstalledExts;
    for (var ext in state.installedExts) {
      notInstalledExts =
          notInstalledExts.where((e) => e.source != ext.source).toList();
    }
    return notInstalledExts;
  }

  List<Metadata> removeExtInstalled(List<Metadata> list) {
    Map<String, Metadata> mapList = {
      for (var element in list) element.name: element
    };
    for (var ext in state.installedExts) {
      if (mapList[ext.metadata.name] != null) {
        mapList.remove(ext.metadata.name);
      }
    }
    return mapList.values.toList();
  }
}
