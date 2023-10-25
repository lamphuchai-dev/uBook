import 'package:flutter/material.dart';
import '../widget/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/tab_home_cubit.dart';

class TabHomePage extends StatefulWidget {
  const TabHomePage({super.key});

  @override
  State<TabHomePage> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  late TabHomeCubit _tabHomeCubit;
  @override
  void initState() {
    _tabHomeCubit = context.read<TabHomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Tab home")),
      body: SizedBox(),
    );
  }
}
