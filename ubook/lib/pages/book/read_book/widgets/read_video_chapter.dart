import 'package:flutter/material.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:video_player/video_player.dart';

class ReadVideoChapter extends StatefulWidget {
  const ReadVideoChapter({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReadVideoChapter> createState() => _ReadVideoChapterState();
}

class _ReadVideoChapterState extends State<ReadVideoChapter> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.chapter.content.first))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
