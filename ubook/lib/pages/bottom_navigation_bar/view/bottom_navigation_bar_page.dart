import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/pages/bookmarks/bookmarks.dart';
import 'package:ubook/pages/home/view/home_view.dart';
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
    final tabs = [const BookmarksView(), const HomeView()];
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
              destinations: const <NavigationDestination>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.bookmark),
                  icon: Icon(Icons.bookmark_border),
                  label: 'Unlearn',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_rounded),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
