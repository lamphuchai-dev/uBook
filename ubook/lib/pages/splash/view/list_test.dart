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
          // position: IndicatorPosition.behind,
          dragText: 'Kéo để quay lại chương',
          armedText: 'Thả để qua chương',
          readyText: 'Đang tải nội dung',
          processedText: "",
          processedDuration: Duration.zero,
          triggerWhenRelease: true,
          hapticFeedback: true,
          succeededIcon: SizedBox(),
          // progressIndicatorSize: 0,
          infiniteOffset: null,
          messageText: ""),
      // header: PhoenixHeader(),
      onRefresh: () async {
        _controller.finishRefresh();
      },
      child: SingleChildScrollView(
        child: Text(text),
      ),
    );
  }
}
