import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/pages/install_extension/cubit/install_extension_cubit.dart';
import 'package:ubook/widgets/widgets.dart';

import 'empty_extensions_widget.dart';
import 'extension_card_widget.dart';

class AllExtensionsWidget extends StatelessWidget {
  const AllExtensionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return BlocBuilder<InstallExtensionCubit, InstallExtensionState>(
      buildWhen: (previous, current) =>
          previous.statusAllExtension != current.statusAllExtension ||
          previous.notInstalledExts.length != current.notInstalledExts.length,
      builder: (context, state) {
        return switch (state.statusAllExtension) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => state.notInstalledExts.isEmpty
              ? const EmptyExtensionsWidget()
              : LayoutBuilder(
                  builder: (context, constraints) => EasyRefresh(
                    onRefresh: () async {
                      return context
                          .read<InstallExtensionCubit>()
                          .onRefreshExtensions();
                    },
                    header: BuilderHeader(
                        triggerOffset: 40,
                        clamping: false,
                        position: IndicatorPosition.above,
                        infiniteOffset: null,
                        processedDuration: Duration.zero,
                        builder: (context, state) {
                          return Stack(
                            children: [
                              SizedBox(
                                height: state.offset,
                                width: double.infinity,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40,
                                  child: SpinKitCircle(
                                    size: 24,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.horizontalPadding),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: state.notInstalledExts
                                .map((meta) => ExtensionCardWidget(
                                    installed: false,
                                    metadataExt: meta,
                                    onTap: () => context
                                        .read<InstallExtensionCubit>()
                                        .onInstallExt(meta.path)))
                                .toList()),
                      ),
                    ),
                  ),
                ),
          _ => const SizedBox()
        };
      },
    );
  }
}
