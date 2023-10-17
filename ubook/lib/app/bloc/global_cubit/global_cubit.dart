import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/constants/colors.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/sharedpref/shared_preference_helper.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit({required SharedPreferenceHelper sharedPreferenceHelper})
      : _preferenceHelper = sharedPreferenceHelper,
        super(const GlobalState(themeMode: ThemeMode.system));

  final SharedPreferenceHelper _preferenceHelper;

  // load data local theme, locale
  void onInit() {
    final nameThemeLocal = _preferenceHelper.themMode;
    if (nameThemeLocal != null) {
      final themeMode = ThemeMode.values
          .firstWhereOrNull((item) => item.name == nameThemeLocal);
      if (themeMode != null && state.themeMode != themeMode) {
        emit(state.copyWith(themeMode: themeMode));

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: AppColors.dark.background,
          ),
        );
      }
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.dark.background,
      ),
    );
  }

  // user change theme app
  void onChangeThemeMode(ThemeMode themeMode) {
    _preferenceHelper.changeThemMode(themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }
}
