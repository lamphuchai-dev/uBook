import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/extensions.dart';

import 'app/routes/routes.dart';
import 'flavors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/bloc/global_cubit/global_cubit.dart';
import 'app/config/flavor_config.dart';
import 'app/theme/themes.dart';
import 'data/sharedpref/shared_preference_helper.dart';
import 'di/components/service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GlobalCubit(
              sharedPreferenceHelper: getIt<SharedPreferenceHelper>())
            ..onInit(),
        ),
      ],
      child: BlocConsumer<GlobalCubit, GlobalState>(
        listenWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        listener: (context, state) {
          final backgroundColor = context.colorScheme.background;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: backgroundColor,
            ),
          );
        },
        buildWhen: (previous, current) {
          if (previous.themeMode != current.themeMode) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return MaterialApp(
            title: FlavorConfig.instance?.name ?? "",
            themeMode: state.themeMode,
            theme: Themes.light,
            darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes.onGenerateRoute,
            initialRoute: Routes.initialRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) => _flavorBanner(
              child: child,
              show: kDebugMode,
            ),
            // scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          );
        },
      ),
    );
  }

  Widget _flavorBanner({
    Widget? child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              child: child,
            )
          : Container(child: child);
}
