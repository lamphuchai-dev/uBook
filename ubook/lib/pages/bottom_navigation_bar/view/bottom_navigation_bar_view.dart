import 'package:flutter/material.dart';
import '../cubit/bottom_navigation_bar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_navigation_bar_page.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({super.key});
  static const String routeName = '/bottom_navigation_bar_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBarCubit()..onInit(),
      child: const BottomNavigationBarPage(),
    );
  }
}
