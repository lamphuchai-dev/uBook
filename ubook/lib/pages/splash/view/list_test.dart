import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class ListTest extends StatefulWidget {
  const ListTest({super.key});

  @override
  State<ListTest> createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {
  late EasyRefreshController _controller;
  @override
  void initState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      header: const ClassicHeader(
          // clamping: true,
          dragText: 'Kéo để quay lại chương',
          armedText: 'Thả để qua chương',
          readyText: 'Đang tải nội dung',
          processedText: "Tải thành công",
          processingText: "Đang tải nội dung",
          processedDuration: Duration.zero,
          triggerWhenRelease: true,
          hapticFeedback: true,
          messageText: "Chương 1: Giới thiệu"),

      footer: const ClassicFooter(
          dragText: 'Kéo để quay lại chương',
          armedText: 'Thả để qua chương',
          readyText: 'Đang tải nội dung',
          processedText: "Tải thành công",
          processingText: "Đang tải nội dung",
          infiniteOffset: null,
          safeArea: false,
          processedDuration: Duration.zero,
          triggerWhenRelease: true,
          hapticFeedback: true,
          messageText: "Chương 1: Giới thiệu"),

      // header: PhoenixHeader(),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        _controller.finishRefresh();
      },
      onLoad: () async {
        await Future.delayed(const Duration(seconds: 1));
        _controller.finishLoad(IndicatorResult.success, true);
      },
      child: SingleChildScrollView(
        child: Text(text),
      ),
    );
  }
}
