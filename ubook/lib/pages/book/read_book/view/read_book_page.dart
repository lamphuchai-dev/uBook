import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/book.dart';
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
    _readBookCubit.onInitFToat(context);
    // SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = context.colorScheme;
    return Scaffold(
      drawer: const BookDrawer(),
      body: BlocBuilder<ReadBookCubit, ReadBookState>(
        buildWhen: (previous, current) =>
            previous.statusType != current.statusType,
        builder: (context, state) {
          return switch (state.statusType) {
            StatusType.loaded => switch (state.extensionStatus) {
                ExtensionStatus.init => const SizedBox(),
                ExtensionStatus.noInstall => Scaffold(
                    appBar: AppBar(),
                    body: const Center(
                      child: Text("Chưa cài extension"),
                    ),
                  ),
                ExtensionStatus.ready => Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                          child: GestureDetector(
                              onTap: _readBookCubit.onTapScreen,
                              onPanDown: (_) => _readBookCubit.onTouchScreen(),
                              child: _ReadChapter(
                                readBookCubit: _readBookCubit,
                              ))),
                      // if (state.book.type != BookType.video)
                      Positioned.fill(
                        child: BlocSelector<ReadBookCubit, ReadBookState,
                            MenuType>(
                          selector: (state) {
                            return state.menuType;
                          },
                          builder: (context, menuType) {
                            return MenuSliderAnimation(
                                menu: menuType,
                                bottomMenu: BottomBaseMenuWidget(
                                    readBookCubit: _readBookCubit),
                                topMenu: TopBaseMenuWidget(
                                  readBookCubit: _readBookCubit,
                                ),
                                autoScrollMenu: AutoScrollMenu(
                                    readBookCubit: _readBookCubit),
                                mediaMenu: const SizedBox(),
                                controller: _animationController);
                          },
                        ),
                      )
                    ],
                  )
              },
            StatusType.error => const Center(
                child: Text(
                  "ERROR",
                  style: TextStyle(fontSize: 27, color: Colors.red),
                ),
              ),
            _ => const LoadingWidget(),
          };
        },
      ),
    );
  }
}

class _ReadChapter extends StatelessWidget {
  const _ReadChapter({required this.readBookCubit});
  final ReadBookCubit readBookCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReadBookCubit, ReadBookState>(
      listenWhen: (previous, current) =>
          previous.readChapter != current.readChapter,
      listener: (context, state) {
        if (state.readChapter?.status == StatusType.init) {
          readBookCubit.getContentsChapter();
        }
      },
      buildWhen: (previous, current) =>
          previous.readChapter != current.readChapter,
      builder: (context, state) {
        if (state.readChapter == null) {
          return const Center(
            child: Text(
              "ERROR",
              style: TextStyle(fontSize: 27, color: Colors.red),
            ),
          );
        }
        return switch (state.readChapter!.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.error => const ChapterLoadingError(),
          StatusType.loaded => switch (readBookCubit.book.type) {
              BookType.comic => ReadChapterWidget(
                  chapter: state.readChapter!.chapter,
                ),
              BookType.video => ReadChapterVideo(
                  chapter: state.readChapter!.chapter,
                ),
              _ => const SizedBox(),
            },
          _ => const LoadingWidget()
        };
      },
    );
  }
}
