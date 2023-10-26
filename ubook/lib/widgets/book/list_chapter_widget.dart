import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/chapter.dart';

enum UsePage { chapters, readChapter }

class ListChaptersWidget extends StatefulWidget {
  const ListChaptersWidget(
      {super.key,
      required this.chapters,
      required this.onTapChapter,
      this.indexSelect,
      this.padding,
      this.usePage = UsePage.chapters});
  final List<Chapter> chapters;
  final int? indexSelect;
  final ValueChanged<Chapter> onTapChapter;
  final EdgeInsetsGeometry? padding;
  final UsePage usePage;

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
        if (valueJumTo > _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.jumpTo(valueJumTo);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: switch (widget.usePage) {
        UsePage.chapters => ListView.separated(
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
                title: Text(
                  chapter.title,
                  style: textTheme.bodyMedium,
                ),
                onTap: () => widget.onTapChapter.call(chapter),
              );
            },
          ),
        UsePage.readChapter => ListView.builder(
            itemCount: widget.chapters.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              final chapter = widget.chapters[index];
              final colorItemSelected = widget.indexSelect == index
                  ? colorScheme.primary
                  : colorScheme.onSurface;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 40,
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: colorItemSelected,
                  ),
                ),
                horizontalTitleGap: 0,
                title: Text(
                  chapter.title,
                  style:
                      textTheme.bodyMedium?.copyWith(color: colorItemSelected),
                ),
                onTap: () => widget.onTapChapter.call(chapter),
              );
            },
          ),
      },
    );
  }
}
