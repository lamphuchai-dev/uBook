import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/pages/book/read_book/read_book.dart';
import 'package:ubook/widgets/widgets.dart';

import '../cubit/bookmarks_cubit.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  // late BookmarksCubit _bookmarksCubit;
  @override
  void initState() {
    // _bookmarksCubit = context.read<BookmarksCubit>();
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
            StatusType.loaded => BooksGridWidget(
                useFetch: false,
                initialBooks: state.books,
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
                          readChapter: book.currentReadChapter ?? 0,
                          fromBookmarks: true,
                          loadChapters: true));
                },
              ),
            _ => const SizedBox()
          };
        },
      ),
    );
  }
}
