import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/utils/system_utils.dart';

import '../cubit/read_book_cubit.dart';

class ReadVideoChapter extends StatefulWidget {
  const ReadVideoChapter({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReadVideoChapter> createState() => _ReadVideoChapterState();
}

class _ReadVideoChapterState extends State<ReadVideoChapter> {
  late final player = Player();
  late final controller = VideoController(player);
  late ReadBookCubit _readBookCubit;

  bool _videoMedia = true;
  @override
  void initState() {
    if (widget.chapter.content.length == 2) {
      _videoMedia = false;
    } else {
      _videoMedia = true;
      player.open(Media(widget.chapter.content.first));
    }
    _readBookCubit = context.read<ReadBookCubit>();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoMedia) {
      return MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(
            volumeGesture: true,
            seekBarMargin:
                const EdgeInsets.only(bottom: 60, left: 16, right: 16),
            brightnessGesture: true,
            // Modify theme options:
            buttonBarButtonSize: 24.0,
            buttonBarButtonColor: Colors.white,
            topButtonBarMargin: const EdgeInsets.only(top: 30),
            topButtonBar: [
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(widget.chapter.title)),
              const Spacer(),
              MaterialCustomButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
            bottomButtonBar: [
              if (widget.chapter.index > 0)
                MaterialCustomButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () {
                    _readBookCubit.onPreviousChapter();
                  },
                ),
              const MaterialPlayOrPauseButton(),
              if (widget.chapter.index > 0)
                MaterialCustomButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () {
                    _readBookCubit.onNextChapter();
                  },
                ),
              const MaterialPositionIndicator(),
              const Spacer(),
              MaterialCustomButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.list),
              ),
              const MaterialFullscreenButton()
            ]),
        fullscreen: const MaterialVideoControlsThemeData(
          seekBarMargin: EdgeInsets.only(bottom: 60, left: 16, right: 16),
        ),
        child: Video(
          controller: controller,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.chapter.title),
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.list_rounded),
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final width = context.width;
          final html = Html(
            data:
                '<iframe  src="${widget.chapter.content.first}" width="$width" height="${(width / 16) * 9}"></iframe>',
            extensions: const [
              IframeHtmlExtension(),
            ],
          );
          return Center(
            child: html,
          );
        },
      ),
    );
  }
}
