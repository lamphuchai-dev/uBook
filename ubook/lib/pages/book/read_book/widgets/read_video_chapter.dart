import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/chapter.dart';

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
          // final html = Html(
          //   data:
          //       '<iframe  src="https://playhydrax.com/?v=2HlXkvf5f" width="$width" height="${(width / 16) * 9}"></iframe>',
          //   extensions: const [
          //     IframeHtmlExtension(),
          //   ],
          // );
          // return Center(
          //   child: html,
          // );

          return ReadVideoWebView(
            url: widget.chapter.content.first,
          );
        },
      ),
    );
  }
}

class ReadVideoWebView extends StatefulWidget {
  const ReadVideoWebView({super.key, required this.url});
  final String url;

  @override
  State<ReadVideoWebView> createState() => _ReadVideoWebViewState();
}

class _ReadVideoWebViewState extends State<ReadVideoWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
          // allowsInlineMediaPlayback: true,
          ));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.infinity,
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InAppWebView(
          key: webViewKey,
          initialData: InAppWebViewInitialData(
              data:
                  '''<iframe style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;overflow:hidden;" frameborder="0" src="${widget.url}" frameborder="0" scrolling="0" allowfullscreen></iframe>'''),
          initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (uri.toString().contains("playhydrax") ||
                uri.toString() == "about:blank" ||
                uri.toString().contains("player")) {
              return NavigationActionPolicy.ALLOW;
            } else {
              return NavigationActionPolicy.CANCEL;
            }
          },
          onCreateWindow: (controller, createWindowAction) async {
            return true;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
