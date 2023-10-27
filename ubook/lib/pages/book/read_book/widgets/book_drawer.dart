import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/pages/book/read_book/cubit/read_book_cubit.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';

class BookDrawer extends StatefulWidget {
  const BookDrawer({super.key});

  @override
  State<BookDrawer> createState() => _BookDrawerState();
}

class _BookDrawerState extends State<BookDrawer> {
  final backgroundColor = Colors.grey;
  late ReadBookCubit _readBookCubit;
  late Book _book;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: backgroundColor,
    //   ),
    // );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _readBookCubit = context.read<ReadBookCubit>();
    _book = _readBookCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Drawer(
      width: context.width * 0.85,
      shape: const RoundedRectangleBorder(),
      child: Column(children: [
        _headerDrawer(),
        Expanded(
          child: ListChaptersWidget(
            indexSelect: _readBookCubit.indexPageChapter,
            chapters: _readBookCubit.chapters,
            usePage: UsePage.readChapter,
            onTapChapter: (chapter) {
              _readBookCubit.onToPageByChapter(chapter);
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
        SafeArea(
          top: false,
          bottom: true,
          child: Container(
            height: 56,
            decoration: BoxDecoration(color: colorScheme.surface),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.download_rounded),
                )),
                Gaps.wGap8,
                Text(
                  "book.downloadBookChapters"
                      .tr(args: [_readBookCubit.chapters.length.toString()]),
                  style: textTheme.titleMedium,
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _headerDrawer() {
    return SizedBox(
      height: context.height * 0.22,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.detailBook,
              arguments: DetailBookArgs(
                  book: _book, extensionModel: _readBookCubit.extension));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: BlurredBackdropImage(
              url: _book.cover,
            )),
            Positioned(
                top: kToolbarHeight,
                left: 16,
                bottom: 10,
                right: 0,
                child: Row(
                  children: [
                    CacheNetWorkImage(_book.cover),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(_book.name),
                          ),
                          Expanded(child: Text(_book.author))
                        ],
                      ),
                    ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
