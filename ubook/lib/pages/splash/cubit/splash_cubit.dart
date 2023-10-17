import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/services/extensions_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required ExtensionsService extensionsService})
      : _extensionsService = extensionsService,
        super(const SplashStateInitial());

  final ExtensionsService _extensionsService;
  void onInit() async {
    emit(const LoadingLocalExts());
    await _extensionsService.onInit();
    emit(const LoadedLocalExts());
  }
}
