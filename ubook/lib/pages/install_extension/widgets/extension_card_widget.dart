import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/extensions.dart';
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

    final result = await widget.onTap.call();

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
                )
              ],
            ),
          ),
          _leadingCardWidget(colorScheme),
        ],
      ),
    );
  }

  Widget _leadingCardWidget(ColorScheme colorScheme) {
    final icon = widget.installed
        ? Icon(
            Icons.delete_forever_rounded,
            color: colorScheme.error,
          )
        : Icon(
            Icons.download_rounded,
            color: colorScheme.primary,
            size: 24,
          );
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: LoadingWidget(
          radius: 10,
          child: icon,
        ),
      );
    }
    return IconButton(onPressed: _onTap, icon: icon);
  }
}
