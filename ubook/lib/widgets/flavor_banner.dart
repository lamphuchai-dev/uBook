// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../app/config/flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  FlavorBanner({super.key, required this.child});
  final Widget child;
  late BannerConfig bannerConfig;

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isProduction()) return child;
    bannerConfig = _getDefaultBanner();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        color: bannerConfig.bannerColor,
        message: bannerConfig.bannerName,
        location: BannerLocation.bottomStart,
        child: child,
      ),
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: FlavorConfig.instance!.env.toString(),
        bannerColor: FlavorConfig.isDevelopment()
            ? Colors.green
            : const Color(0xffFFDE00));
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;
  BannerConfig({required this.bannerName, required this.bannerColor});
}
