import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
class CardThemes {
  static CardTheme light = CardTheme(
      color: AppColors.light.cardBackground,
      shape: Constants.shape,
      margin: EdgeInsets.zero,
      elevation: Constants.elevation);
  static CardTheme dark = CardTheme(
      color: AppColors.dark.cardBackground,
      shape: Constants.shape,
      margin: EdgeInsets.zero,
      elevation: Constants.elevation);
}
