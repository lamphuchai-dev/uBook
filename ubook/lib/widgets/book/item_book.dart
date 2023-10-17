import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/widgets/cache_network_image.dart';

enum BookLayoutType { column, stack }

class ItemBook extends StatelessWidget {
  const ItemBook(
      {super.key,
      required this.book,
      this.onTap,
      this.onLongTap,
      this.layout = BookLayoutType.column,
      this.bookMark = false});
  final Book book;
  final bool bookMark;
  final BookLayoutType layout;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Builder(
          builder: (context) => switch (layout) {
                BookLayoutType.column => Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: Dimens.cardBookBorderRadius,
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(child: _coverBook()),
                                  Positioned(
                                      left: 0, top: 0, child: _cardPercent()),
                                ],
                              ))),
                      Gaps.hGap4,
                      _info()
                    ],
                  ),
                BookLayoutType.stack => Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: Dimens.cardBookBorderRadius,
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(child: _coverBook()),
                                  Positioned(
                                      left: 0, top: 0, child: _cardPercent()),
                                ],
                              ))),
                    ],
                  ),
              }),
    );
  }

  Widget _coverBook() {
    return CacheNetWorkImage(book.cover);
  }

  Widget _cardPercent() {
    if (bookMark) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))),
        // child: Text(
        //   "${book.chapterCount}c - ${book.getPercentRead}%",
        //   style: const TextStyle(fontSize: 12),
        // ),
      );
    }
    return const SizedBox();
  }

  Widget _info() {
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: Text(
            book.name.toTitleCase(),
            style: const TextStyle(fontSize: 15, height: 1),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          book.description,
          style: const TextStyle(fontSize: 11, height: 0.8),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}

class BookLayout {}
