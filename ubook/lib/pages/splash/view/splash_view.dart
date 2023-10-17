import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';
import '../cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_page.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashCubit(extensionsService: getIt<ExtensionsService>())..onInit(),
      child: const SplashPage(),
    );
  }
}
