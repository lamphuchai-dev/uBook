import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/pages/home/widget/tab_bar_widget.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late HomeCubit _homeCubit;

  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // return Scaffold(
        //     appBar: AppBar(
        //       title: const Text("Home"),
        //     ),
        //     body: Text(
        //       state.tabs.length.toString(),
        //     ));
        return DefaultTabController(
          length: state.tabs.length,
          child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
                    isScrollable: true,
                    tabs: state.tabs
                        .map((itemTab) => Tab(
                              text: itemTab.title,
                            ))
                        .toList())),
            body: TabBarView(
                children:
                    state.tabs.map((itemTab) => TabBarWidget(pagePlugin: itemTab)).toList(),
          ),
        ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
