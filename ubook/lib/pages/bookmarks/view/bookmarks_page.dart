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

  Widget _girdBook(List<Book> books) {
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
      onLongTap: _openBottomSheet,
    );
  }

  void _openBottomSheet(Book book) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BookBottomSheet(
              book: book,
              bookmarksCubit: _bookmarksCubit,
            ));
  }

  Widget _buildBooks(List<Book> books) {
    if (books.isEmpty) {
      return const EmptyListDataWidget(
        svgType: SvgType.defaultSvg,
      );
    } else if (books.length < 3) {
      return _girdBook(books);
    } else if (books.length == 3) {
      return BooksSlider(
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
        onLongTapBook: _openBottomSheet,
      );
    } else {
      final list = _bookmarksCubit.getBooks(books);
      return Column(
        children: [
          BooksSlider(
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
            onLongTapBook: _openBottomSheet,
          ),
          Gaps.hGap8,
          Expanded(child: _girdBook(list.$2))
        ],
      );
    }
  }
}
