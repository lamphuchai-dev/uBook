import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';

import '../cubit/read_book_cubit.dart';

class ChapterContent extends StatefulWidget {
  const ChapterContent(
      {super.key,
      required this.chapter,
      required this.pageController,
      required this.getChapterContent});
  final Chapter chapter;
  final PageController pageController;
  final Future<Chapter> Function() getChapterContent;

  @override
  State<ChapterContent> createState() => _ChapterContentState();
}

class _ChapterContentState extends State<ChapterContent> {
  late ScrollController _scrollController;

  double? _heightScreen;
  late ReadBookCubit _readBookCubit;

  late StatusType _statusType;
  late Chapter _chapter;

  bool _autoScroll = false;

  @override
  void initState() {
    _statusType = StatusType.init;
    _chapter = widget.chapter;
    if (mounted) {
      _getChapterContent();
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_handlerScrollListener);
    _readBookCubit = context.read<ReadBookCubit>();

    super.initState();
  }

  void _handlerScrollListener() {
    _calculateContentPagination();
  }

  void _calculateContentPagination() {
    try {
      final heightContentFull = _scrollController.position.maxScrollExtent;
      final heightCurrentContent = _scrollController.offset;
      _heightScreen ??= context.height;
      final value = ContentPagination(
          sliderValue: (heightCurrentContent / heightContentFull) * 100,
          totalPage: heightContentFull ~/ _heightScreen! == 0
              ? 1
              : heightContentFull ~/ _heightScreen!,
          currentPage: heightCurrentContent ~/ _heightScreen! == 0
              ? 1
              : heightCurrentContent ~/ _heightScreen!);
      _readBookCubit.setContentPagination(value);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void _getChapterContent() async {
    try {
      setState(() {
        _statusType = StatusType.loading;
      });
      _chapter = await widget.getChapterContent.call();
      if (mounted) {
        setState(() {
          _statusType = StatusType.loaded;
        });
      }
    } catch (error) {
      setState(() {
        _statusType = StatusType.error;
      });
    }
  }

  void _closeAutoScroll() {
    _scrollController.position.hold(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<ReadBookCubit, ReadBookState>(
          listenWhen: (previous, current) {
            if (previous.runtimeType != current.runtimeType) {
              return true;
            }
            if (previous is AutoScrollReadBook &&
                current is AutoScrollReadBook &&
                widget.chapter == _readBookCubit.currentChapter) {
              if (previous.timerScroll != current.timerScroll) {
                _handlerAutoScroll();
                return true;
              }
              if (previous.scrollStatus != current.scrollStatus) {
                return true;
              }
              return false;
            }
            return false;
          },
          listener: (context, state) {
            if (state is AutoScrollReadBook &&
                widget.chapter == _readBookCubit.currentChapter) {
              switch (state.scrollStatus) {
                case AutoScrollStatus.start:
                  _handlerAutoScroll();
                  break;
                case AutoScrollStatus.pause:
                case AutoScrollStatus.stop:
                  _closeAutoScroll();
                  break;
                default:
                  break;
              }
            } else if (_autoScroll) {
              _closeAutoScroll();
              _autoScroll = false;
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: kToolbarHeight,
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   alignment: Alignment.bottomLeft,
          //   child: Text(
          //     widget.chapter.title,
          //     style: textTheme.bodySmall?.copyWith(fontSize: 12),
          //   ),
          // ),
          Expanded(
              child: switch (_statusType) {
            StatusType.loading => const LoadingWidget(),
            StatusType.loaded => SingleChildScrollView(
                physics: _readBookCubit.getPhysicsScroll(),
                controller: _scrollController,
                child: BlocBuilder<ReadBookCubit, ReadBookState>(
                  builder: (context, state) {
                    final headers = {
                      "Referer": _readBookCubit.book.getSourceByBookUrl()
                    };
                    return switch (_readBookCubit.bookType) {
                      BookType.comic => Column(
                          children: _chapter.content
                              .map((e) => CacheNetWorkImage(
                                    e,
                                    fit: BoxFit.fitWidth,
                                    width: width,
                                    headers: headers,
                                    placeholder: Container(
                                        height: 200,
                                        alignment: Alignment.center,
                                        child: const SpinKitPulse(
                                          color: Colors.grey,
                                        )),
                                  ))
                              .toList(),
                        ),
                      _ => const SizedBox()
                    };
                  },
                ),
              ),
            StatusType.error => const Center(
                child: Icon(Icons.error),
              ),
            _ => const SizedBox()
          }),
          // _buildFooterWidget()
        ],
      ),
    );
  }

  // Widget _buildFooterWidget() {
  //   const textStyle = TextStyle(fontSize: 11);
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //     child: Row(
  //       children: [
  //         Text(
  //           "${widget.chapter.index}/${_readBookCubit.book.totalChapter}",
  //           style: textStyle,
  //           textAlign: TextAlign.left,
  //         ),
  //         ValueListenableBuilder(
  //           valueListenable: _contentPaginationValue,
  //           builder: (context, value, child) {
  //             if (value == null) return const SizedBox();
  //             return Text(
  //               value.formatText,
  //               style: textStyle,
  //               textAlign: TextAlign.right,
  //             );
  //           },
  //         )
  //       ].expandedEqually().toList(),
  //     ),
  //   );
  // }

  void _handlerAutoScroll() async {
    final state = _readBookCubit.state;
    if (state is! AutoScrollReadBook) return;
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _readBookCubit.onAutoScrollNexPage();
    }
    final height = context.height;
    final heightText =
        _scrollController.position.maxScrollExtent - _scrollController.offset;
    double timer = (heightText / height) * state.timerScroll;
    if (timer <= 0) timer = 0.5;
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: timer.toInt()),
        curve: Curves.linear);
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _readBookCubit.onAutoScrollNexPage();
    }
    _autoScroll = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
