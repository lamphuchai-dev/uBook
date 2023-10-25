import 'package:flutter/material.dart';
import '../cubit/tab_home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tab_home_page.dart';

class TabHomeView extends StatelessWidget {
  const TabHomeView({super.key});
  static const String routeName = '/tab_home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabHomeCubit()..onInit(),
      child: const TabHomePage(),
    );
  }
}
