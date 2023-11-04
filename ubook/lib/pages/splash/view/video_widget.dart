import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

import 'hls_tracks_page.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    //  https://cdn.animevui.com/file/6e7f0fb5e2a7640a0bd69b3c05975e95

    return HlsTracksPage();
    return Scaffold(
      appBar: AppBar(),
      body: YoYoPlayer(
          aspectRatio: 16 / 9,
          // Url (Video streaming links)
          // 'https://dsqqu7oxq6o1v.cloudfront.net/preview-9650dW8x3YLoZ8.webm',
          // "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          // "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
          url: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
          videoStyle: const VideoStyle(
            qualityStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            forwardAndBackwardBtSize: 30.0,
            playButtonIconSize: 40.0,
            playIcon: Icon(
              Icons.add_circle_outline_outlined,
              size: 40.0,
              color: Colors.white,
            ),
            pauseIcon: Icon(
              Icons.remove_circle_outline_outlined,
              size: 40.0,
              color: Colors.white,
            ),
            videoQualityPadding: EdgeInsets.all(5.0),
          ),
          videoLoadingStyle: const VideoLoadingStyle(
            loading: Center(
              child: Text("Loading video"),
            ),
          ),
          allowCacheFile: true,
          onCacheFileCompleted: (files) {
            print('Cached file length ::: ${files?.length}');

            if (files != null && files.isNotEmpty) {
              for (var file in files) {
                print('File path ::: ${file.path}');
              }
            }
          },
          onCacheFileFailed: (error) {
            print('Cache file error ::: $error');
          },
          onFullScreen: (value) {}),
    );
  }
}
