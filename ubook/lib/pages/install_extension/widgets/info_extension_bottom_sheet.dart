import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/metadata.dart';
import 'package:ubook/widgets/widgets.dart';

class InfoExtensionBottomSheet extends StatelessWidget {
  const InfoExtensionBottomSheet({super.key, required this.metadata});
  final Metadata metadata;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        child: BaseBottomSheetUi(
            child: Column(
          children: [
            Gaps.hGap16,
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: _leadingCardWidget,
                ),
                Gaps.wGap16,
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.name,
                      style: textTheme.titleLarge,
                    ),
                    Gaps.hGap4,
                    Text(
                      metadata.source,
                      style: textTheme.titleSmall,
                    ),
                    Gaps.hGap8,
                    Row(
                      children: [
                        TagExtension(
                          text: "V${metadata.version}",
                          color: Colors.orange,
                        ),
                        Gaps.wGap8,
                        TagExtension(
                          text: metadata.locale.split("_").last,
                          color: Colors.teal,
                        ),
                        Gaps.wGap8,
                        TagExtension(
                          text: metadata.type.name.toTitleCase(),
                          color: colorScheme.primary,
                        ),
                        Gaps.wGap8,
                        if (metadata.tag != null)
                          TagExtension(
                            text: metadata.tag!,
                            color: colorScheme.error,
                          ),
                      ],
                    )
                  ],
                ))
              ],
            ),
            Gaps.hGap12,
            _RowChild(metadata.description, 'Giới thiệu'),
            Gaps.hGap8,
            _RowChild(metadata.author, 'Tác giả'),
            Gaps.hGap8,
            _RowChild(metadata.type.name.toString(), 'Thể loại'),
            Gaps.hGap8,
            _RowChild(metadata.locale, 'Ngôn ngữ'),
            Gaps.hGap8,
            _RowChild(metadata.version.toString(), 'Phiên bản'),
            Gaps.hGap8,
            if (metadata.tag != null) _RowChild(metadata.tag ?? "", 'Tag'),
            Container(
              height: 24,
            )
          ],
        )),
      ),
    );
  }

  Widget get _leadingCardWidget {
    if (metadata.icon == "") {
      return const SizedBox();
    }

    if (metadata.icon.startsWith("https")) {
      return CachedNetworkImage(imageUrl: metadata.icon);
    } else {
      try {
        final file = File(metadata.icon);
        return Image.file(file);
      } catch (e) {
        return const SizedBox();
      }
    }
  }
}

class _RowChild extends StatelessWidget {
  const _RowChild(this.value, this.title);
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: Text(title)),
        Gaps.wGap8,
        Expanded(flex: 2, child: Text(value))
      ],
    );
  }
}
