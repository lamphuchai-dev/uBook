import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/extension.dart';

class SelectExtensionBottomSheet extends StatelessWidget {
  const SelectExtensionBottomSheet(
      {super.key,
      required this.extensions,
      required this.onSelected,
      required this.exceptionPrimary});
  final List<Extension> extensions;
  final ValueChanged<Extension> onSelected;
  final Extension exceptionPrimary;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 1,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: colorScheme.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12))),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8)),
                                height: 6,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Text("Các tiện ích đã cài đặt",
                                  style: textTheme.titleMedium),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, RoutesName.installExt);
                                    },
                                    icon: const Icon(Icons.more_vert)),
                              ))
                            ],
                          ),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverGrid.builder(
                        itemCount: extensions.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 58,
                                mainAxisSpacing: 12),
                        itemBuilder: (context, index) {
                          final ext = extensions[index];
                          return ExtensionCard(
                            extension: ext,
                            isPrimary: exceptionPrimary.metadata.source ==
                                ext.metadata.source,
                            onTap: () {
                              if (exceptionPrimary.metadata.source !=
                                  ext.metadata.source) {
                                onSelected.call(ext);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ExtensionCard extends StatelessWidget {
  const ExtensionCard(
      {super.key,
      required this.extension,
      required this.onTap,
      this.isPrimary = false});
  final Extension extension;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final uri = Uri.parse(extension.metadata.source);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isPrimary
                ? colorScheme.primary.withOpacity(0.7)
                : colorScheme.surface,
            borderRadius: Dimens.cardBookBorderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              extension.metadata.name,
              style: textTheme.titleMedium,
            ),
            Text(
              uri.host,
              style:
                  textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
