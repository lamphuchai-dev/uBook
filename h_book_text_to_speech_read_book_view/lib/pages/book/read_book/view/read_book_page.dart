import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:h_book/services/system_chrome_service.dart';

import '../cubit/read_book_cubit.dart';
import '../widgets/widgets.dart';

class ReadBookPage extends StatefulWidget {
  const ReadBookPage({super.key});

  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage>
    with SingleTickerProviderStateMixin {
  late ReadBookCubit _readBookCubit;
  late AnimationController _animationController;
  final backgroundColor = const Color(0xffDDDDDD).withOpacity(0.96);

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    SystemChromeService.setSystemUIOverlayStyleReadBookPage();
    _readBookCubit = context.read<ReadBookCubit>();
    _readBookCubit.setMenuAnimationController(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const BookDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
              child: SafeArea(
            bottom: false,
            child: GestureDetector(
              onTap: _readBookCubit.onTapScreen,
              onPanDown: (_) => _readBookCubit.onTouchScreen(),
              child: BlocBuilder<ReadBookCubit, ReadBookState>(
                buildWhen: (previous, current) =>
                    previous.chapters != current.chapters ||
                    previous.runtimeType != current.runtimeType,
                builder: (context, state) {
                  return PageView.builder(
                    physics: _readBookCubit.getPhysicsScroll(),
                    scrollDirection: Axis.vertical,
                    itemCount: state.chapters.length,
                    controller: _readBookCubit.pageController,
                    onPageChanged: _readBookCubit.onPageChanged,
                    itemBuilder: (context, index) => ItemChapterWidget(
                      chapter: state.chapters[index],
                    ),
                  );
                },
              ),
            ),
          )),
          BlocBuilder<ReadBookCubit, ReadBookState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              Menu menu = Menu.base;
              if (state is ReadBookAutoScroll) {
                menu = Menu.autoScroll;
              } else if (state is ReadBookMedia) {
                menu = Menu.media;
              }
              return MenuSliderAnimation(
                  menu: menu,
                  bottomMenu: const BottomBaseMenuWidget(),
                  topMenu: const TopBaseMenuWidget(),
                  autoScrollMenu: const AutoScrollMenuWidget(),
                  mediaMenu: const MediaMenuWidget(),
                  controller: _animationController);
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChromeService.setSystemUIOverlayStyleDefault();
    _animationController.dispose();
    super.dispose();
  }
}
