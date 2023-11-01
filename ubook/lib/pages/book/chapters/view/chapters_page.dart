import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/pages/book/read_book/read_book.dart';
import 'package:ubook/widgets/widgets.dart';
import '../cubit/chapters_cubit.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late ChaptersCubit _chaptersCubit;
  late Book _book;
  @override
  void initState() {
    _chaptersCubit = context.read<ChaptersCubit>();
    _book = _chaptersCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.name),
        actions: const [
          // IconButton(
          //     onPressed: () {
          //       // _chaptersCubit.sortChapterType();
          //     },
          //     icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        child: BlocBuilder<ChaptersCubit, ChaptersState>(
          builder: (context, state) {
            if (state.statusType == StatusType.loading) {
              return const LoadingWidget();
            }
            final chapters = state.chapters;
            return Column(
              children: [
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    "${chapters.length} ${"book.chapter".tr()}",
                    style: textTheme.bodyMedium,
                  ),
                  trailing: PopupMenuButton<SortChapterType>(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: SortChapterType.newChapter,
                          child: Text(
                            "book.new_chapter".tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    state.sortType == SortChapterType.newChapter
                                        ? colorScheme.primary
                                        : null),
                          ),
                          onTap: () {
                            _chaptersCubit
                                .sortChapterType(SortChapterType.newChapter);
                          },
                        ),
                        PopupMenuItem(
                          value: SortChapterType.lastChapter,
                          child: Text(
                            "book.last_chapter".tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color: state.sortType ==
                                        SortChapterType.lastChapter
                                    ? colorScheme.primary
                                    : null),
                          ),
                          onTap: () {
                            _chaptersCubit
                                .sortChapterType(SortChapterType.lastChapter);
                          },
                        )
                      ];
                    },
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.sortType == SortChapterType.newChapter
                              ? "book.new_chapter".tr()
                              : "book.last_chapter".tr()),
                          const Icon(Icons.expand_more)
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                Expanded(
                    child: ListChaptersWidget(
                  chapters: chapters,
                  onTapChapter: (chapter) {
                    final chaptersSor = _chaptersCubit.sort(
                        chapters, SortChapterType.lastChapter);
                    Navigator.pushNamed(context, RoutesName.readBook,
                        arguments: ReadBookArgs(
                            book: _book,
                            chapters: chaptersSor,
                            readChapter: chapter.index,
                            fromBookmarks: false,
                            loadChapters: false));
                  },
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
