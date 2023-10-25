import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/pages/install_extension/cubit/install_extension_cubit.dart';
import 'package:ubook/widgets/widgets.dart';

import 'empty_extensions_widget.dart';
import 'extension_card_widget.dart';

class InstalledExtensionsWidget extends StatelessWidget {
  const InstalledExtensionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallExtensionCubit, InstallExtensionState>(
      // buildWhen: (previous, current) =>
      //     previous.statusInstalled != current.statusInstalled ||
      //     previous.installedExts.length != current.installedExts.length,
      builder: (context, state) {
        return switch (state.statusInstalled) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => state.installedExts.isEmpty
              ? const EmptyExtensionsWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontalPadding),
                  child: Column(
                      children: state.installedExts
                          .map((ext) => ExtensionCardWidget(
                              installed: true,
                              metadataExt: ext.metadata,
                              onTap: () => context
                                  .read<InstallExtensionCubit>()
                                  .onUninstallExt(ext)))
                          .toList()),
                ),
          _ => const SizedBox()
        };
      },
    );
  }
}
