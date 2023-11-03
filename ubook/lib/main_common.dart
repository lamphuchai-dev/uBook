import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ubook/app/bloc/debug/bloc_observer.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/utils/device_utils.dart';
import 'package:ubook/utils/system_utils.dart';
import 'app.dart';
import 'app/constants/constants.dart';

FutureOr<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUtils.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupLocator();

  await DeviceUtils.initWakelock();
  SystemUtils.setDefaultPreferredOrientations();
  MediaKit.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
