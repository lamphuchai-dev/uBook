import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/pages/book/read_book/widgets/book_drawer.dart';
import 'package:ubook/pages/home/cubit/home_cubit.dart';
import 'package:ubook/utils/system_utils.dart';
import 'package:ubook/widgets/widgets.dart';
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
  late ColorScheme colorScheme;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _readBookCubit = context.read<ReadBookCubit>();
    _readBookCubit.setMenuAnimationController(_animationController);
    SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = context.colorScheme;
    return Scaffold(
      drawer: const BookDrawer(),
      drawerEnableOpenDragGesture: false,
      body: BlocBuilder<ReadBookCubit, ReadBookState>(
        builder: (context, state) {
          if (state is ReadBookInitial) {
            if (state.extensionStatus == ExtensionStatus.error) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(
                  child: Text("Chưa cài extension"),
                ),
              );
            }
            return const LoadingWidget();
          }
          final chapters = _readBookCubit.chapters;

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _readBookCubit.onTapScreen,
                  onPanDown: (_) => _readBookCubit.onTouchScreen(),
                  child: BlocBuilder<ReadBookCubit, ReadBookState>(
                    buildWhen: (previous, current) =>
                        previous.totalChapters != current.totalChapters ||
                        previous.runtimeType != current.runtimeType,
                    builder: (context, state) {
                      return PageView.builder(
                        allowImplicitScrolling: false,
                        controller: _readBookCubit.pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: chapters.length,
                        onPageChanged: _readBookCubit.onPageChanged,
                        physics: _readBookCubit.getPhysicsScroll(),
                        itemBuilder: (context, index) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is! OverscrollNotification) {
                                return false;
                              }
                              if (_readBookCubit.pageController?.page == 0.0 &&
                                  notification.overscroll < 0) {
                                return false;
                              }
                              _readBookCubit.pageController?.jumpTo(
                                  _readBookCubit.pageController!.offset +
                                      notification.overscroll * 1.2);
                              return false;
                            },
                            child: ReadComicContent(
                              chapter: chapters[index],
                              pageController: _readBookCubit.pageController!,
                              getChapterContent: () => _readBookCubit
                                  .getChapterContent(chapters[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                  height: 20,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildFooterWidget()),
              BlocBuilder<ReadBookCubit, ReadBookState>(
                buildWhen: (previous, current) =>
                    previous.runtimeType != current.runtimeType,
                builder: (context, state) {
                  Menu menu = Menu.base;
                  if (state is AutoScrollReadBook) {
                    menu = Menu.autoScroll;
                  }
                  return MenuSliderAnimation(
                      menu: menu,
                      bottomMenu: const BottomBaseMenuWidget(),
                      topMenu: TopBaseMenuWidget(
                        book: _readBookCubit.book,
                      ),
                      autoScrollMenu: const AutoScrollMenuWidget(),
                      mediaMenu: const SizedBox(),
                      controller: _animationController);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFooterWidget() {
    const textStyle = TextStyle(fontSize: 11);
    return ValueListenableBuilder(
      valueListenable: _readBookCubit.readChapter,
      builder: (context, value, child) {
        if (value != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.black54,
            child: Row(
              children: [
                Text(
                  "${value.index + 1}/${_readBookCubit.chapters.length}",
                  style: const TextStyle(fontSize: 11),
                ),
                ValueListenableBuilder(
                  valueListenable: _readBookCubit.contentPaginationValue,
                  builder: (context, value, child) {
                    if (value == null) return const SizedBox();
                    return Text(
                      value.formatText,
                      style: textStyle,
                      textAlign: TextAlign.right,
                    );
                  },
                )
              ].expandedEqually().toList(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  void dispose() {
    SystemUtils.setSystemNavigationBarColor(colorScheme.background);
    super.dispose();
  }
}
