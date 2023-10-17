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
            statusType: StatusType.init)) {
    _streamSubscription = extensionManager.extensionsChange.listen((exts) {
      emit(state.copyWith(installedExts: exts));
    });
  }

  final ExtensionsService _extensionManager;
  late StreamSubscription? _streamSubscription;

  bool fromToHome = false;

  void onInit() async {
    if (state.installedExts.isNotEmpty) {
      fromToHome = true;
    }
    final list = await _extensionManager.getListExts();
    emit(state.copyWith(notInstalledExts: list));
  }

  Future<bool> onInstallExt(String extUrl) async {
    final isInstallExt = await _extensionManager.installExtensionByUrl(extUrl);
    if (isInstallExt != null) {
      final exts = state.notInstalledExts;
      final noIn =
          exts.where((ext) => ext.source != isInstallExt.source).toList();
      emit(state.copyWith(notInstalledExts: noIn));
    }
    return isInstallExt != null;
  }

  Future<bool> onUninstallExt(Extension extension) async {
    final result = await _extensionManager.uninstallExtension(extension);
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

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
