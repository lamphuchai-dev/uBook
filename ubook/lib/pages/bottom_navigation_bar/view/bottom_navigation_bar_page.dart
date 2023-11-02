import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/pages/bookmarks/bookmarks.dart';
import 'package:ubook/pages/discovery/discovery.dart';
import '../cubit/bottom_navigation_bar_cubit.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  late BottomNavigationBarCubit _bottomNavigationBarCubit;
  @override
  void initState() {
    _bottomNavigationBarCubit = context.read<BottomNavigationBarCubit>();
    // SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [const BookmarksView(), const DiscoveryView()];
    return BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
      buildWhen: (previous, current) =>
          previous.indexSelected != current.indexSelected,
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.indexSelected, children: tabs),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: context.colorScheme.surface))),
            child: NavigationBar(
              elevation: 0,
              onDestinationSelected:
                  _bottomNavigationBarCubit.onChangeIndexSelected,
              selectedIndex: state.indexSelected,
              backgroundColor: context.colorScheme.background,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  selectedIcon: const Icon(Icons.bookmark),
                  icon: const Icon(Icons.bookmark_border),
                  label: 'bookmark.title'.tr(),
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.widgets_rounded),
                  icon: const Icon(Icons.widgets_outlined),
                  label: "discovery.title".tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
