// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/pages/book/read_book/cubit/read_book_cubit.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';

class ReadChapterWidget extends StatefulWidget {
  const ReadChapterWidget({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReadChapterWidget> createState() => _ReadChapterWidgetState();
}

class _ReadChapterWidgetState extends State<ReadChapterWidget> {
  late final ReadBookCubit _readBookCubit;
  late ScrollController _scrollController;

  ValueNotifier<ContentsPage> _contentsPage = ValueNotifier(const ContentsPage(
      maxScrollExtent: 0, pages: 0, currentPage: 0, show: false));

  double? _heightScreen;
  Timer? _timerAutoScroll;
  double _maxScrollExtent = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_timerAutoScroll != null) {
        _timerAutoScroll?.cancel();
      }
      _timerAutoScroll = Timer(const Duration(seconds: 1), () {
        _contentsPage.value = _contentsPage.value.copyWith(show: false);
      });

      if (_readBookCubit.state.menuType == MenuType.autoScroll &&
          _readBookCubit.state.controlStatus != ControlStatus.pause) {
        if (_maxScrollExtent != _scrollController.position.maxScrollExtent) {
          _handlerAutoScroll();
        }
      }
      _calculateContents();
    });

    _readBookCubit = context.read<ReadBookCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_readBookCubit.state.menuType == MenuType.autoScroll) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          _handlerAutoScroll();
          _readBookCubit.handlerAutoScroll ??= _handlerAutoScroll;
        });
      }
    });

    super.initState();
  }

  void _calculateContents() {
    _maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;
    _heightScreen ??= context.height;
    final totalPages = _maxScrollExtent ~/ _heightScreen! == 0
        ? 1
        : _maxScrollExtent ~/ _heightScreen!;
    final currentPage = currentOffset ~/ _heightScreen! == 0
        ? 1
        : currentOffset ~/ _heightScreen!;
    _contentsPage.value = ContentsPage(
        maxScrollExtent: _maxScrollExtent,
        pages: totalPages,
        currentPage: currentPage,
        show: true);
  }

  void _handlerAutoScroll() async {
    _maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset == _maxScrollExtent) {
      _readBookCubit.onNextChapter();
      return;
    }
    _heightScreen ??= context.height;
    _maxScrollExtent = _scrollController.position.maxScrollExtent;
    final heightText = _maxScrollExtent - _scrollController.offset;
    double timer =
        (heightText / _heightScreen!) * _readBookCubit.timeAutoScroll.value;
    if (timer <= 0) timer = 0.5;
    await _scrollController.animateTo(_maxScrollExtent,
        duration: Duration(seconds: timer.toInt()), curve: Curves.linear);
    if (_scrollController.offset == _maxScrollExtent) {
      _readBookCubit.onNextChapter();
    }
  }

  void _closeAutoScroll() {
    _scrollController.position.hold(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final headers = {"Referer": _readBookCubit.book.getSourceByBookUrl};
    final width = context.width;
    final textTheme = context.appTextTheme;
    return Stack(
      children: [
        Positioned.fill(
          child: BlocConsumer<ReadBookCubit, ReadBookState>(
              listenWhen: (previous, current) =>
                  previous.controlStatus != current.controlStatus,
              listener: (context, state) {
                switch (state.controlStatus) {
                  case ControlStatus.init:
                  case ControlStatus.start:
                    _handlerAutoScroll();
                    _readBookCubit.handlerAutoScroll ??= _handlerAutoScroll;
                    break;
                  case ControlStatus.stop:
                  case ControlStatus.pause:
                  case ControlStatus.none:
                    _closeAutoScroll();
                    _readBookCubit.handlerAutoScroll = null;
                    break;
                  default:
                    break;
                }
              },
              buildWhen: (previous, current) =>
                  previous.menuType != current.menuType,
              builder: (_, state) => EasyRefresh(
                    header: ClassicHeader(
                        dragText: 'Kéo để quay lại chương trước',
                        armedText: 'Thả để qua chương trước',
                        readyText: 'Đang tải nội dung',
                        processedText: "Tải thành công",
                        processingText: "Đang tải nội dung",
                        processedDuration: Duration.zero,
                        triggerWhenRelease: true,
                        triggerWhenReach:
                            _readBookCubit.previousChapter == null,
                        hapticFeedback: true,
                        messageText: _readBookCubit.previousChapter == null
                            ? "Không có chương trước đó"
                            : _readBookCubit.previousChapter!.title),
                    footer: ClassicFooter(
                        dragText: 'Kéo để qua chương mới',
                        armedText: 'Thả để qua chương mới',
                        readyText: 'Đang tải nội dung',
                        processedText: "Tải thành công",
                        processingText: "Đang tải nội dung",
                        infiniteOffset: null,
                        safeArea: false,
                        processedDuration: Duration.zero,
                        // triggerWhenRelease: true,
                        hapticFeedback: true,
                        messageText: _readBookCubit.nextChapter == null
                            ? "Bạn đã xem chương mới nhất"
                            : _readBookCubit.nextChapter!.title),
                    onRefresh: _readBookCubit.onPreviousChapter,
                    onLoad: _readBookCubit.onNextChapter,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: _readBookCubit.getPhysicsScroll,
                      child: Column(
                          children: widget.chapter.content.map((src) {
                        if (src.startsWith("http")) {
                          return CacheNetWorkImage(
                            src,
                            fit: BoxFit.fitWidth,
                            width: width,
                            headers: headers,
                            placeholder: Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: const SpinKitPulse(
                                  color: Colors.grey,
                                )),
                          );
                        } else if (!src.startsWith("http")) {
                          return ImageFileWidget(
                            pathFile: src,
                          );
                        }
                        return const SizedBox();
                      }).toList()),
                    ),
                  )),
        ),
        Positioned(
            right: 16,
            top: 0,
            child: SafeArea(
              child: ValueListenableBuilder(
                  valueListenable: _contentsPage,
                  builder: (context, value, child) {
                    return AnimatedFade(
                      status: value.show,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          "${value.currentPage}/${value.pages}",
                          style: textTheme.labelSmall?.copyWith(fontSize: 11),
                        ),
                      ),
                    );
                  }),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _readBookCubit.handlerAutoScroll = null;
    super.dispose();
  }
}

class ImageFileWidget extends StatelessWidget {
  const ImageFileWidget({super.key, required this.pathFile});
  final String pathFile;

  @override
  Widget build(BuildContext context) {
    final file = File(pathFile);
    if (file.existsSync()) {
      return Image.file(File(pathFile));
    }
    return const SizedBox();
  }
}

class ContentsPage {
  final double maxScrollExtent;
  final int pages;
  final int currentPage;
  final bool show;
  const ContentsPage(
      {required this.maxScrollExtent,
      required this.pages,
      required this.currentPage,
      this.show = false});

  ContentsPage copyWith({
    double? maxScrollExtent,
    int? pages,
    int? currentPage,
    bool? show,
  }) {
    return ContentsPage(
        maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
        pages: pages ?? this.pages,
        currentPage: currentPage ?? this.currentPage,
        show: show ?? this.show);
  }

  @override
  String toString() =>
      'ContentsPage(maxScrollExtent: $maxScrollExtent, pages: $pages, currentPage: $currentPage)';
}
