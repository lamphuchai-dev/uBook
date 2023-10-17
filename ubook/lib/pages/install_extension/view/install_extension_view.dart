import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';
import '../cubit/install_extension_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'install_extension_page.dart';

class InstallExtensionView extends StatelessWidget {
  const InstallExtensionView({super.key});
  static const String routeName = '/install_extension_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InstallExtensionCubit(extensionManager: getIt<ExtensionsService>())
            ..onInit(),
      child: const InstallExtensionPage(),
    );
  }
}
