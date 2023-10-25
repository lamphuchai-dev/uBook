import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/pages/book/read_book/read_book.dart';
import 'package:ubook/pages/bookmarks/widgets/widgets.dart';
import 'package:ubook/widgets/book/item_book.dart';
import 'package:ubook/widgets/widgets.dart';

import '../cubit/bookmarks_cubit.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late BookmarksCubit _bookmarksCubit;
  @override
  void initState() {
    _bookmarksCubit = context.read<BookmarksCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Bookmarks")),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          return switch (state.statusType) {
            StatusType.loading => const LoadingWidget(),
            StatusType.loaded => _buildBooks(state.books),
            _ => const SizedBox()
          };
        },
      ),
    );
  }

  Widget _buildBooks(List<Book> books) {
    if (books.isEmpty) {
      return const EmptyListDataWidget(
        svgType: SvgType.defaultSvg,
      );
    } else if (books.length < 3) {
      return BooksGridWidget(
        useFetch: false,
        initialBooks: books,
        useRefresh: false,
        listenBooks: true,
        layout: BookLayoutType.stack,
        onFetchListBook: (page) async {
          return [];
        },
        onTap: (book) {
          Navigator.pushNamed(context, RoutesName.readBook,
              arguments: ReadBookArgs(
                  book: book,
                  chapters: [],
                  readChapter: book.readBook?.index ?? 0,
                  fromBookmarks: true,
                  loadChapters: true));
        },
      );
    } else if (books.length == 3) {
      return BooksSlider(
        nameExtension: _bookmarksCubit.getNameExtensionBySource,
        books: books,
        onTapBook: (book) {
          Navigator.pushNamed(context, RoutesName.readBook,
              arguments: ReadBookArgs(
                  book: book,
                  chapters: [],
                  readChapter: book.readBook?.index ?? 0,
                  fromBookmarks: true,
                  loadChapters: true));
        },
      );
    } else {
      final list = _bookmarksCubit.getBooks(books);
      return Column(
        children: [
          BooksSlider(
            nameExtension: _bookmarksCubit.getNameExtensionBySource,
            books: list.$1,
            onTapBook: (book) {
              Navigator.pushNamed(context, RoutesName.readBook,
                  arguments: ReadBookArgs(
                      book: book,
                      chapters: [],
                      readChapter: book.readBook?.index ?? 0,
                      fromBookmarks: true,
                      loadChapters: true));
            },
          ),
          Gaps.hGap8,
          Expanded(
              child: BooksGridWidget(
            useFetch: false,
            initialBooks: list.$2,
            layout: BookLayoutType.stack,
            useRefresh: false,
            listenBooks: true,
            onFetchListBook: (page) async {
              return [];
            },
            onTap: (book) {
              Navigator.pushNamed(context, RoutesName.readBook,
                  arguments: ReadBookArgs(
                      book: book,
                      chapters: [],
                      readChapter: book.readBook?.index ?? 0,
                      fromBookmarks: true,
                      loadChapters: true));
            },
          ))
        ],
      );
    }
  }
}
