import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://scontent-fml20-1.xx.fbcdn.net/v/t39.25447-2/10000000_1724265114745186_8230993226350961511_n.mp4?_nc_cat=103&vs=c568bf9fd386a1f9&_nc_vs=HBksFQAYJEdJQ1dtQUJpdWFuQk5TQUdBR2VqUzgyNlhEcHlibWRqQUFBRhUAAsgBABUAGCRHSUNXbUFCckhmd2FSb1FEQU9MNnNqYTJRT1ZGYnY0R0FBQUYVAgLIAQBLB4gScHJvZ3Jlc3NpdmVfcmVjaXBlATENc3Vic2FtcGxlX2ZwcwAQdm1hZl9lbmFibGVfbnN1YgAgbWVhc3VyZV9vcmlnaW5hbF9yZXNvbHV0aW9uX3NzaW0AKGNvbXB1dGVfc3NpbV9vbmx5X2F0X29yaWdpbmFsX3Jlc29sdXRpb24AHXVzZV9sYW5jem9zX2Zvcl92cW1fdXBzY2FsaW5nABFkaXNhYmxlX3Bvc3RfcHZxcwAVACUAHIwXQAAAAAAAAAAREQAAACa%2Br%2FixjNPOAxUCKAJDMxgLdnRzX3ByZXZpZXccF0CWm3O2RaHLGCFkYXNoX2dlbjJod2Jhc2ljX2hxMl9mcmFnXzJfdmlkZW8SABgYdmlkZW9zLnZ0cy5jYWxsYmFjay5wcm9kOBJWSURFT19WSUVXX1JFUVVFU1QbCogVb2VtX3RhcmdldF9lbmNvZGVfdGFnBm9lcF9oZBNvZW1fcmVxdWVzdF90aW1lX21zATAMb2VtX2NmZ19ydWxlB3VubXV0ZWQTb2VtX3JvaV9yZWFjaF9jb3VudAEwEW9lbV9pc19leHBlcmltZW50AAxvZW1fdmlkZW9faWQPNjcyODAzODg0NjMxMTcxEm9lbV92aWRlb19hc3NldF9pZBAxMjQ3NDkwMDg1OTIwMDA0FW9lbV92aWRlb19yZXNvdXJjZV9pZBAxMDE3Mzc2MzM2MTg2MzM1HG9lbV9zb3VyY2VfdmlkZW9fZW5jb2RpbmdfaWQPOTkzNjMyOTc4NDA4MTU4DnZ0c19yZXF1ZXN0X2lkACUCHAAljgIbCIgBcwQ4MTI5AmNkCjIwMjMtMTEtMDUDcmNiATADYXBwBnVwbG9hZAJjdBlDT05UQUlORURfUE9TVF9BVFRBQ0hNRU5UE29yaWdpbmFsX2R1cmF0aW9uX3MIMTQ0Ni44NjQBZgJhZAJ0cxVwcm9ncmVzc2l2ZV9lbmNvZGluZ3MA&ccb=1-7&_nc_sid=5588c3&efg=eyJ2ZW5jb2RlX3RhZyI6Im9lcF9oZCJ9&_nc_ohc=NYj9edX4uVoAX8uSmKJ&_nc_ht=scontent-fml20-1.xx&edm=APRAPSkEAAAA&oh=00_AfBh_XxoqZc9t3hvOAoSQyDUZ4W8sRy_bkEXwg8d4YnZNw&oe=654CC59C&_nc_rid=034517297149578&_nc_store_type=0'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
