// ignore_for_file: unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/metadata.dart';
import 'package:ubook/widgets/widgets.dart';
import '../cubit/install_extension_cubit.dart';
import '../widgets/widgets.dart';

class InstallExtensionPage extends StatefulWidget {
  const InstallExtensionPage({super.key});

  @override
  State<InstallExtensionPage> createState() => _InstallExtensionPageState();
}

class _InstallExtensionPageState extends State<InstallExtensionPage> {
  late InstallExtensionCubit _installExtensionCubit;
  @override
  void initState() {
    _installExtensionCubit = context.read<InstallExtensionCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Tiện ích bổ mở rộng"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(2),
              // decoration: const BoxDecoration(color: Colors.black12),
              decoration: ShapeDecoration(
                  color: colorScheme.surface, shape: const StadiumBorder()),

              child: TabBar(
                  indicatorWeight: 0,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelStyle:
                      const TextStyle(color: Colors.orange, fontSize: 16),
                  labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  labelColor: Colors.white,
                  padding: const EdgeInsets.all(1.5),
                  indicator: ShapeDecoration(
                      color: colorScheme.primary, shape: const StadiumBorder()),
                  tabs: const [
                    Tab(
                      text: "Đã cài đặt",
                    ),
                    Tab(
                      text: "Chưa cài đặt",
                    )
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: [
          KeepAliveWidget(child: _tabInstalledExtChild()),
          KeepAliveWidget(child: _tabNotInstalledExtChild())
        ]),
        // floatingActionButton: _installExtensionCubit.fromToHome
        //     ? null
        //     : FloatingActionButton(
        //         onPressed: () {
        //           if (_installExtensionCubit.onDone()) {
        //             Navigator.pushReplacementNamed(
        //                 context, RoutesName.bottomNav);
        //           }
        //         },
        //         child: const Icon(Icons.navigate_next),
        //       ),
      ),
    );
  }

  Widget _tabInstalledExtChild() {
    return BlocBuilder<InstallExtensionCubit, InstallExtensionState>(
      builder: (context, state) {
        final exts = state.installedExts;
        if (exts.isEmpty) {
          return const EmptyExtension();
        }

        return SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: exts
                  .map(
                    (ext) => ExtensionCardWidget(
                      metadataExt: ext.metadata,
                      installed: true,
                      onTap: () => _installExtensionCubit.onUninstallExt(ext),
                    ),
                  )
                  .toList()),
        );
      },
    );
  }

  Widget _tabNotInstalledExtChild() {
    return BlocBuilder<InstallExtensionCubit, InstallExtensionState>(
      builder: (context, state) {
        final exts = _installExtensionCubit.getListExts();

        if (exts.isEmpty) {
          return const EmptyExtension();
        }
        return ListView.builder(
          itemCount: exts.length,
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
          itemBuilder: (context, index) {
            final ext = exts[index];
            return ExtensionCardWidget(
              metadataExt: ext,
              installed: false,
              onTap: () => _installExtensionCubit.onInstallExt(ext.path),
            );
          },
        );
      },
    );
  }
}

class _ExtensionCard extends StatelessWidget {
  const _ExtensionCard(
      {super.key,
      required this.extension,
      required this.onTap,
      this.installed = false});
  final Metadata extension;
  final VoidCallback onTap;
  final bool installed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    final uri = Uri.parse(extension.source);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.surface),
          borderRadius: BorderRadius.circular(Dimens.radius)),
      child: Row(
        children: [
          Gaps.wGap8,
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
          ),
          Gaps.wGap8,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  extension.name,
                  style: textTheme.titleMedium,
                ),
                Text(
                  uri.host,
                  style: textTheme.bodySmall,
                )
              ],
            ),
          ),
          IconButton(
              onPressed: onTap,
              icon: installed
                  ? Icon(
                      Icons.delete_forever_rounded,
                      color: colorScheme.error,
                    )
                  : Icon(
                      Icons.download_rounded,
                      color: colorScheme.primary,
                    )),
          Gaps.wGap4,
        ],
      ),
    );
  }
}

class EmptyExtension extends StatelessWidget {
  const EmptyExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.3,
          ),
          const Icon(
            Icons.extension_off_rounded,
            size: 100,
          ),
        ],
      ),
    );
  }
}

class _DialogInstallExtension extends StatelessWidget {
  const _DialogInstallExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Gaps.wGap14,
            LoadingWidget(
              radius: 8,
              child: Icon(
                Icons.circle,
                size: 16,
                color: context.colorScheme.primary,
              ),
            ),
            Gaps.wGap14,
            const Expanded(child: Text("Đang cài đặt extension"))
          ],
        ),
      ),
    );
  }
}
