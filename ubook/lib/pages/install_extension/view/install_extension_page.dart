// ignore_for_file: unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/widgets/widgets.dart';
import '../widgets/widgets.dart';

class InstallExtensionPage extends StatefulWidget {
  const InstallExtensionPage({super.key});

  @override
  State<InstallExtensionPage> createState() => _InstallExtensionPageState();
}

class _InstallExtensionPageState extends State<InstallExtensionPage> {
  // late InstallExtensionCubit _installExtensionCubit;
  @override
  void initState() {
    // _installExtensionCubit = context.read<InstallExtensionCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Expanded(
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      splashBorderRadius: BorderRadius.circular(40),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: textTheme.titleMedium,
                      labelColor: textTheme.titleMedium?.color,
                      tabs: const [
                    Tab(
                      text: "Đã cài đặt",
                    ),
                    Tab(
                      text: "Tất cả",
                    )
                  ]))
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: TabBarView(children: [
            KeepAliveWidget(child: InstalledExtensionsWidget()),
            KeepAliveWidget(child: AllExtensionsWidget())
          ]),
        ),
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
