import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';

class BottomSheetThemes {
  static final light = BottomSheetThemeData(
      backgroundColor: AppColors.light.background,
      shape: Constants.bottomSheetShape);

  static final dark = BottomSheetThemeData(
      backgroundColor: AppColors.dark.background,
      shape: Constants.bottomSheetShape);
}
