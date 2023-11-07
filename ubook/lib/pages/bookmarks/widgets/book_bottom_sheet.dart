import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:ubook/app/constants/constants.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/pages/bookmarks/cubit/bookmarks_cubit.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';

class BookBottomSheet extends StatelessWidget {
  const BookBottomSheet(
      {super.key, required this.book, required this.bookmarksCubit});
  final Book book;
  final BookmarksCubit bookmarksCubit;

  @override
  Widget build(BuildContext context) {
    final texTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final extBook = bookmarksCubit.getExtension(book.getSourceByBookUrl);
    return Container(
      decoration: BoxDecoration(
        borderRadius: Constants.bottomSheetShape.borderRadius,
        color: context.colorScheme.background,
      ),
      child: BaseBottomSheetUi(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
          child: Column(
            children: [
              // Gaps.hGap8,
              Container(
                alignment: Alignment.centerLeft,
                // height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: TextScroll(
                      book.bookUrl,
                      mode: TextScrollMode.endless,
                      velocity: const Velocity(pixelsPerSecond: Offset(80, 0)),
                      delayBefore: const Duration(milliseconds: 500),
                      numberOfReps: 5,
                      pauseBetween: const Duration(seconds: 2),
                      style: texTheme.labelSmall,
                      textAlign: TextAlign.right,
                      selectable: true,
                    )),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: book.bookUrl));
                        },
                        icon: const Icon(Icons.content_copy_rounded))
                  ],
                ),
              ),
              SizedBox(
                height: 170,
                child: Row(
                  children: [
                    SizedBox(
                      child: CacheNetWorkImage(book.cover),
                    ),
                    Gaps.wGap12,
                    Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gaps.hGap12,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.name,
                                  style: texTheme.titleLarge,
                                ),
                                Gaps.hGap4,
                                Text(
                                  book.author,
                                  style: texTheme.bodySmall,
                                ),
                              ],
                            )),
                            Text(
                              "Nguồn : ${extBook == null ? "Chưa cài đặt" : extBook.metadata.name}",
                              style: texTheme.bodySmall,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Gaps.hGap16,
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.surface),
                      onPressed: () {
                        Navigator.pop(context);

                        if (extBook == null) {
                        } else {
                          Navigator.pushNamed(context, RoutesName.detail,
                              arguments: book.bookUrl);
                        }
                      },
                      child: const Icon(Icons.info_rounded)),
                  Gaps.wGap8,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.surface),
                      onPressed: () {
                        Share.share(book.bookUrl);
                      },
                      child: const Icon(Icons.share)),
                  Gaps.wGap8,
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surface),
                        onPressed: () async {},
                        child: Row(
                          children: [
                            const Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.download_rounded),
                            )),
                            Gaps.wGap8,
                            Text(
                              "book.export".tr(),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        )),
                  )
                ],
              ),
              Gaps.hGap16,
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      onPressed: () async {
                        bookmarksCubit.onTapDelete(book);
                        Navigator.pop(context);
                      },
                      // child: const Icon(Icons.delete_rounded))
                      child: Row(
                        children: [
                          const Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete_rounded),
                          )),
                          Gaps.wGap8,
                          Text(
                            "common.delete".tr(),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                  Gaps.wGap8,
                  Expanded(
                      flex: 3,
                      child: ElevatedButton(
                          onPressed: () {
                            bookmarksCubit.downloadBook(book);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.download_rounded),
                              )),
                              Gaps.wGap8,
                              Text(
                                "book.downloadBook".tr(),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
