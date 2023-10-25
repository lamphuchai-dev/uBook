import 'package:flutter/material.dart';
import '../cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = '/home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..onInit(),
      child: const HomePage(),
    );
  }
}
