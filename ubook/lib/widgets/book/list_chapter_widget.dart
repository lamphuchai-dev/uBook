import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/chapter.dart';

class ListChaptersWidget extends StatefulWidget {
  const ListChaptersWidget(
      {super.key,
      required this.chapters,
      required this.onTapChapter,
      this.indexSelect,
      this.padding});
  final List<Chapter> chapters;
  final int? indexSelect;
  final ValueChanged<Chapter> onTapChapter;
  final EdgeInsetsGeometry? padding;

  @override
  State<ListChaptersWidget> createState() => _ListChaptersWidgetState();
}

class _ListChaptersWidgetState extends State<ListChaptersWidget> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.indexSelect != null) {
        final valueJumTo = widget.indexSelect! * 56.0;
        // if (valueJumTo > _scrollController.position.) return;
        _scrollController.jumpTo(valueJumTo);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return ListView.separated(
      padding: widget.padding,
      itemCount: widget.chapters.length,
      controller: _scrollController,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: colorScheme.surface,
      ),
      itemBuilder: (context, index) {
        final chapter = widget.chapters[index];
        return ListTile(
          // contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          tileColor: widget.indexSelect == index ? colorScheme.surface : null,
          title: Text(
            chapter.title,
            style: textTheme.bodyMedium,
          ),
          onTap: () => widget.onTapChapter.call(chapter),
        );
      },
    );
  }
}
