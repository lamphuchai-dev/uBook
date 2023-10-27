import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ubook/app/bloc/debug/bloc_observer.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/utils/system_utils.dart';
import 'app.dart';
import 'app/constants/constants.dart';

FutureOr<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUtils.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupLocator();

  Bloc.observer = const AppBlocObserver();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
