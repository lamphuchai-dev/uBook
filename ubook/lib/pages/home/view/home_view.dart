import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/storage_service.dart';
import '../cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = '/home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          storageService: getIt<StorageService>(),
          extensionManager: getIt<ExtensionsService>())
        ..onInit(),
      child: const HomePage(),
    );
  }
}
