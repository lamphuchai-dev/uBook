import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/services/storage_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/discovery_cubit.dart';
import 'discovery_page.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({super.key});
  static const String routeName = '/discovery_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoveryCubit(
          storageService: getIt<StorageService>(),
          extensionManager: getIt<ExtensionsService>(),
          jsRuntime: getIt<JsRuntime>())
        ..onInit(),
      child: const DiscoveryPage(),
    );
  }
}
