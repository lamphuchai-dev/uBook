// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ubook/app/extensions/index.dart';

import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/widgets/loading_widget.dart';

import '../cubit/read_book_cubit.dart';

class ReadChapterVideo extends StatefulWidget {
  const ReadChapterVideo({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReadChapterVideo> createState() => _ReadChapterVideoState();
}

class _ReadChapterVideoState extends State<ReadChapterVideo> {
  final GlobalKey _webViewKey = GlobalKey();

  Player? _player;
  VideoController? _videoController;

  List<_ChapterVideo> _listVideo = [];
  _ChapterVideo? _currentVideo;

  InAppWebViewController? _webViewController;

  InAppWebViewGroupOptions? _optionsWebView;

  late ReadBookCubit _readBookCubit;

  bool _loading = false;

  @override
  void initState() {
    if (widget.chapter.contentVideo != null &&
        widget.chapter.contentVideo!.isNotEmpty) {
      _listVideo = widget.chapter.contentVideo!
          .map((e) => _ChapterVideo.fromMap(e))
          .toList();
      initPlayVideo(_listVideo.first);
    }

    _readBookCubit = context.read<ReadBookCubit>();

    super.initState();
  }

  void initPlayVideo(_ChapterVideo chapterVideo) {
    switch (chapterVideo.type) {
      case "video":
        if (_player == null && _videoController == null) {
          _onInitVideoPlayer();
        }
        _player!.open(Media(chapterVideo.url));
        break;
      case "iframe":
        if (_optionsWebView == null) {
          _onInitWebView();
        }
        if (_webViewController != null) {
          _webViewController?.loadData(data: "");
        }
        break;
      default:
        break;
    }

    setState(() {
      _currentVideo = chapterVideo;
    });
  }

  void _onInitVideoPlayer() {
    _player = Player();
    _videoController = VideoController(_player!);
  }

  void _onInitWebView() {
    _optionsWebView = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            supportZoom: false),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions());
  }

  @override
  Widget build(BuildContext context) {
    if (_currentVideo == null) {
      return const Center(
        child: Text("ERROR"),
      );
    }
    return switch (_currentVideo!.type) {
      "video" => _videoWidget(),
      "iframe" => _webViewVideo(),
      _ => const SizedBox()
    };
  }

  Widget _videoWidget() {
    return MaterialVideoControlsTheme(
      normal: MaterialVideoControlsThemeData(
          volumeGesture: true,
          seekBarMargin: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
          brightnessGesture: true,
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
        controller: _videoController!,
      ),
    );
  }

  Widget _webViewVideo() {
    final data =
        '''<iframe style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;" frameborder="0" src="${_currentVideo!.url}" frameborder="0" scrolling="0" allowfullscreen></iframe>''';
    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: [
            const Positioned.fill(
                child: ColoredBox(
              color: Colors.transparent,
            )),
            SafeArea(
              child: Align(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: InAppWebView(
                    key: _webViewKey,
                    initialData: InAppWebViewInitialData(data: data),
                    initialOptions: _optionsWebView,
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                      setState(() {
                        _loading = true;
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (["about"].contains(uri.scheme)) {
                        return NavigationActionPolicy.ALLOW;
                      }
                      final tmp =
                          uri.toString().checkByRegExp(r'playhydrax|player');
                      print(tmp);
                      if (uri.toString().contains("playhydrax") ||
                          uri.toString() == "about:blank" ||
                          uri.toString().contains("player")) {
                        return NavigationActionPolicy.ALLOW;
                      }
                      return NavigationActionPolicy.CANCEL;
                    },
                    onCreateWindow: (controller, createWindowAction) async {
                      return true;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        _loading = true;
                      });
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        _loading = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            Positioned.fill(
                child: _loading
                    ? Container(
                        color: context.colorScheme.background,
                        child: const LoadingWidget())
                    : const SizedBox())
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _ChapterVideo {
  final String url;
  final String type;
  final String? regex;
  _ChapterVideo({
    required this.url,
    required this.type,
    this.regex,
  });

  _ChapterVideo copyWith({
    String? url,
    String? type,
    String? regex,
  }) {
    return _ChapterVideo(
      url: url ?? this.url,
      type: type ?? this.type,
      regex: regex ?? this.regex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type,
      'regex': regex,
    };
  }

  factory _ChapterVideo.fromMap(Map<String, dynamic> map) {
    return _ChapterVideo(
      url: map['url'] as String,
      type: map['type'] as String,
      regex: map['regex'] != null ? map['regex'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory _ChapterVideo.fromJson(String source) =>
      _ChapterVideo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => '_ChapterVideo(url: $url, type: $type, regex: $regex)';

  @override
  bool operator ==(covariant _ChapterVideo other) {
    if (identical(this, other)) return true;

    return other.url == url && other.type == type && other.regex == regex;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode ^ regex.hashCode;
}