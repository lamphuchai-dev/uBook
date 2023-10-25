
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:h_book/app/constants/app_colors.dart';
import 'package:h_book/app/extensions/extensions.dart';

import 'app/router/app_router.dart';
import 'di/service_locator.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(false);
    WebView.debugLoggingSettings.enabled = false;
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await NotificationService.initializeLocalNotifications();
  NotificationService.initializeNotificationsEventListeners();

  await setupLocator();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              background: AppColors.backgroundColor),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(color: AppColors.backgroundColor),
          sliderTheme: SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
            valueIndicatorColor: Colors.grey,
            valueIndicatorTextStyle: const TextStyle(color: Colors.black),
            trackHeight: 0.7,
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: context.appTheme.iconTheme.color,
            inactiveTrackColor: Colors.grey,
            thumbColor: context.appTheme.iconTheme.color,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8.0,
              pressedElevation: 1.0,
            ),
          )),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.initialRoute,
      // home: ContentPageWidget(),
    );
  }
}
