import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ubook/widgets/cache_network_image.dart';

class BlurredBackdropImage extends StatelessWidget {
  const BlurredBackdropImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CacheNetWorkImage(url),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9.0),
              child: const SizedBox(),
            ),
          ),
        )
      ],
    );
  }
}
