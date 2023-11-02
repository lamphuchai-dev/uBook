import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/widgets/widgets.dart';

class ExtensionCardWidget extends StatefulWidget {
  const ExtensionCardWidget(
      {super.key,
      required this.metadataExt,
      required this.installed,
      required this.onTap});
  final Metadata metadataExt;
  final bool installed;
  final Future<bool> Function() onTap;

  @override
  State<ExtensionCardWidget> createState() => _ExtensionCardWidgetState();
}

class _ExtensionCardWidgetState extends State<ExtensionCardWidget> {
  bool _loading = false;

  void _onTap() async {
    setState(() {
      _loading = true;
    });

    await widget.onTap.call();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    final uri = Uri.parse(widget.metadataExt.source);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.5),
          border: Border.all(color: colorScheme.surface),
          borderRadius: BorderRadius.circular(Dimens.radius)),
      child: Row(
        children: [
          Gaps.wGap8,
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: _leadingCardWidget,
          ),
          Gaps.wGap8,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.metadataExt.name,
                  style: textTheme.titleMedium,
                ),
                Text(
                  uri.host,
                  style: textTheme.bodySmall,
                ),
                Gaps.hGap4,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: colorScheme.primary,
                      )),
                  child: Text(
                    widget.metadataExt.type.name.toTitleCase(),
                    style: textTheme.labelSmall?.copyWith(fontSize: 8),
                  ),
                )
              ],
            ),
          ),
          _tradingCardWidget(colorScheme),
        ],
      ),
    );
  }

  Widget get _leadingCardWidget {
    if (widget.metadataExt.icon == "") {
      return const SizedBox();
    }

    if (widget.metadataExt.icon.startsWith("https")) {
      return CachedNetworkImage(imageUrl: widget.metadataExt.icon);
    } else {
      try {
        final file = File(widget.metadataExt.icon);
        return Image.file(file);
      } catch (e) {
        return const SizedBox();
      }
    }
  }

  Widget _tradingCardWidget(ColorScheme colorScheme) {
    Widget icon = widget.installed
        ? Icon(
            Icons.delete_forever_rounded,
            color: colorScheme.error,
            size: 24,
          )
        : Icon(
            Icons.download_rounded,
            color: colorScheme.primary,
            size: 24,
          );
    if (_loading) {
      return Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.only(right: 8),
        child: LoadingWidget(
          radius: 10,
          child: icon,
        ),
      );
    }
    return IconButton(splashRadius: 20, onPressed: _onTap, icon: icon);
  }
}
