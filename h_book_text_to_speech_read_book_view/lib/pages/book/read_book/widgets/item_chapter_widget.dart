// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/data/models/chapter.dart';

import '../cubit/read_book_cubit.dart';

class ItemChapterWidget extends StatefulWidget {
  const ItemChapterWidget({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ItemChapterWidget> createState() => _ItemChapterWidgetState();
}

class _ItemChapterWidgetState extends State<ItemChapterWidget>
    with AutomaticKeepAliveClientMixin {
  late ReadBookCubit _readBookCubit;
  late ScrollController _scrollController;
  late ValueNotifier<ContentPagination?> _contentPaginationValue;

  double? _heightScreen;
  @override
  void initState() {
    _contentPaginationValue = ValueNotifier(null);
    _readBookCubit = context.read<ReadBookCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_handlerScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateContentPagination();
    });
    super.initState();
  }

  void _handlerScrollListener() {
    _calculateContentPagination();
  }

  void _calculateContentPagination() {
    final heightContentFull = _scrollController.position.maxScrollExtent;
    final heightCurrentContent = _scrollController.offset;
    _heightScreen ??= context.height;
    _contentPaginationValue.value = ContentPagination(
        sliderValue: (heightCurrentContent / heightContentFull) * 100,
        totalPage: heightContentFull ~/ _heightScreen! == 0
            ? 1
            : heightContentFull ~/ _heightScreen!,
        currentPage: heightCurrentContent ~/ _heightScreen! == 0
            ? 1
            : heightCurrentContent ~/ _heightScreen!);
  }

  void tmp() async {
    final state = _readBookCubit.state;
    if (state is! ReadBookAutoScroll) return;
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Chương ${widget.chapter.index} : ${widget.chapter.name}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is! OverscrollNotification) return false;
                if (_readBookCubit.pageController.page == 0.0 &&
                    notification.overscroll < 0) {
                  return false;
                }
                _readBookCubit.pageController.jumpTo(
                    _readBookCubit.pageController.offset +
                        notification.overscroll * 1.2);
                return false;
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                controller: _scrollController,
                physics: _readBookCubit.getPhysicsScroll(),
                child: BlocConsumer<ReadBookCubit, ReadBookState>(
                  listenWhen: (previous, current) {
                    if (previous.runtimeType != current.runtimeType) {
                      return true;
                    }
                    if (previous is ReadBookAutoScroll &&
                        current is ReadBookAutoScroll) {
                      if (previous.timerScroll != current.timerScroll) {
                        tmp();
                        return false;
                      }
                      if (previous.scrollStatus != current.scrollStatus) {
                        return true;
                      }
                      return false;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state is ReadBookAutoScroll) {
                      print("AutoScrollStatus : ${state.scrollStatus}");
                      switch (state.scrollStatus) {
                        case AutoScrollStatus.start:
                          tmp();
                          break;
                        case AutoScrollStatus.pause:
                        case AutoScrollStatus.stop:
                          _scrollController.position.hold(() {});
                          break;
                        default:
                          break;
                      }
                    }
                  },
                  buildWhen: (previous, current) {
                    if (previous.runtimeType != current.runtimeType) {
                      return true;
                    }
                    if (previous is ReadBookMedia &&
                        current is ReadBookMedia &&
                        current.chapter.index == widget.chapter.index &&
                        previous.textSpeak != current.textSpeak) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is ReadBookMedia) {
                      return mediaChapter(state.textSpeak);
                    }
                    return baseChapter();
                  },
                ),
              ),
            ),
          ),
          _buildFooterWidget()
        ],
      ),
    );
  }

  Widget mediaChapter(String value) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _listTextContent.map((text) {
          if (value == "" || !text.contains(value)) {
            return TextChapter(
              text: "    $text",
              textStyle: const TextStyle(fontSize: 18),
              onOffset: (value) {
                if (value.dy >= 0 &&
                    text != "" &&
                    _readBookCubit.indexTextSpeakChapter == null) {
                  final index = _listTextContent.indexOf(text);
                  _readBookCubit
                      .setIndexTextSpeak(value.dy > 10 ? index : index + 1);
                }
              },
            );
          }
          return TextChapter(
              text: "    $text",
              key: UniqueKey(),
              onHeight: (offset, height) {
                if (offset > context.height) {
                  _scrollController
                      .jumpTo(_scrollController.offset + offset - height);
                }
              },
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  background: Paint()
                    ..color = const Color(0xffF2A7B3)
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 3));
        }).toList());
  }

  Widget baseChapter() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _listTextContent
            .map((text) =>
                Text("    $text", style: const TextStyle(fontSize: 18)))
            .toList());
  }

  List<String> get _listTextContent => widget.chapter.content.split("\n");

  Widget _buildFooterWidget() {
    const textStyle = TextStyle(fontSize: 11);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "${widget.chapter.index}/${_readBookCubit.getTotalChapters}",
            style: textStyle,
            textAlign: TextAlign.left,
          ),
          ValueListenableBuilder(
            valueListenable: _contentPaginationValue,
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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TextChapter extends StatefulWidget {
  const TextChapter(
      {super.key,
      required this.text,
      required this.textStyle,
      this.onOffset,
      this.onHeight});
  final String text;
  final TextStyle textStyle;
  final ValueChanged<Offset>? onOffset;
  final Function(double offset, double height)? onHeight;

  @override
  State<TextChapter> createState() => _TextChapterState();
}

class _TextChapterState extends State<TextChapter> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _globalKey.currentContext?.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);
      widget.onOffset?.call(offset);
      widget.onHeight?.call(
          offset.dy + renderBox.size.height / 2 + kToolbarHeight,
          renderBox.size.height + kToolbarHeight + 40);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text, key: _globalKey, style: widget.textStyle);
  }
}

class ContentPagination {
  final int totalPage;
  final int currentPage;
  final double sliderValue;
  ContentPagination(
      {required this.totalPage,
      required this.currentPage,
      required this.sliderValue});

  String get formatText => "$currentPage/$totalPage";

  int get remainingPages => totalPage - currentPage;

  ContentPagination copyWith({
    int? totalPage,
    int? currentPage,
    double? sliderValue,
  }) {
    return ContentPagination(
        totalPage: totalPage ?? this.totalPage,
        currentPage: currentPage ?? this.currentPage,
        sliderValue: sliderValue ?? this.sliderValue);
  }

  @override
  String toString() =>
      'ContentPagination(totalPage: $totalPage, currentPage: $currentPage)';
}
