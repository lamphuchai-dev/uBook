import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';

class BooksSlider extends StatelessWidget {
  const BooksSlider(
      {super.key,
      required this.books,
      required this.onTapBook,
      required this.onLongTapBook});
  final List<Book> books;
  final ValueChanged<Book> onTapBook;
  final ValueChanged<Book> onLongTapBook;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          enlargeCenterPage: true,
          height: context.height * 0.23,
          viewportFraction: 0.85,
          initialPage: 0,
          enlargeFactor: 0.35,
          // autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: books.map((book) {
          return Builder(
            builder: (BuildContext context) {
              return _ItemBookSlider(
                book: book,
                nameExtension: book.readBook?.nameExtension ?? "",
                onTap: () => onTapBook(book),
                onLongTap: () => onLongTapBook(book),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _ItemBookSlider extends StatelessWidget {
  const _ItemBookSlider(
      {required this.book,
      required this.onTap,
      required this.nameExtension,
      required this.onLongTap});
  final Book book;
  final String nameExtension;
  final VoidCallback onTap;
  final VoidCallback onLongTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Positioned.fill(
                child: BlurredBackdropImage(
              url: book.cover,
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 25),
            )),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CacheNetWorkImage(
                            book.cover,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        )),
                    Gaps.wGap8,
                    Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: Text(
                                    book.name,
                                    style: textTheme.titleMedium,
                                  )),
                                  if (book.readBook != null)
                                    Text(
                                      book.readBook!.titleChapter!,
                                      maxLines: 2,
                                      style: textTheme.labelSmall,
                                    )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameExtension,
                                      style: textTheme.bodySmall,
                                    ),
                                    Text(
                                      "${book.readBook?.index != null ? book.readBook!.index! + 1 : 1}/${book.totalChapters}",
                                      style: textTheme.titleSmall
                                          ?.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  textDateString(
                                    book.updateAt!,
                                  ),
                                  style: textTheme.titleSmall
                                      ?.copyWith(fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String textDateString(DateTime dateTime) {
    try {
      final dateNow = DateTime.now();
      if (dateTime.year == dateNow.year &&
          dateTime.month == dateNow.month &&
          dateTime.day == dateNow.day) {
        if (dateTime.hour == dateNow.hour) {
          final minute = dateNow.minute - dateTime.minute;
          if (minute == 0) return "date.now".tr();
          return "$minute ${"date.minute".tr()}";
        } else {
          return "${dateNow.hour - dateTime.hour} ${"date.hour".tr()}";
        }
      } else {
        if (dateTime.year == dateNow.year && dateTime.month == dateNow.month) {
          if (dateNow.day - 1 == dateTime.day) return "date.yesterday".tr();
          final startOfWeekday =
              dateNow.subtract(Duration(days: dateNow.weekday - 1));
          if (dateTime.isAfter(startOfWeekday) && dateTime.isBefore(dateNow)) {
            final days = [
              "monday",
              "tuesday",
              "wednesday",
              "thursday",
              "friday",
              "saturday",
              "sunday"
            ];
            return "date.${days[dateTime.weekday]}".tr();
          }
        }
        return "${dateTime.day}:${dateTime.month}";
      }
    } catch (error) {
      // error.toString().log(tag: "ListNotificationCubit::textDate");
    }
    return "";
  }
}
