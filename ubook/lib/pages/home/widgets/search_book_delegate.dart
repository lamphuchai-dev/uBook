import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/data/models/extension.dart';

import '../../../widgets/book/books_grid_widget.dart';

typedef OnSearchBook = Future<List<Book>> Function(String keyWord, int page);

class SearchBookDelegate extends SearchDelegate {
  final OnSearchBook onSearchBook;
  final Extension extensionModel;
  SearchBookDelegate(
      {required this.onSearchBook, required this.extensionModel});

  List<Book> _listBook = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final tmp = super.appBarTheme(context).inputDecorationTheme;
    // return super
    //     .appBarTheme(context)
    //     .copyWith(colorScheme: context.colorScheme);
    return context.appTheme.copyWith(inputDecorationTheme: tmp);
  }

  int page = 0;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          if (_listBook.isNotEmpty) {
            _listBook.clear();
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }
    return BooksGridWidget(
      onFetchListBook: (page) => onSearchBook(query, page),
      useRefresh: false,
      emptyWidget: _noSearchResults(),
      onChangeBooks: (value) {
        _listBook = value;
      },
      onTap: (book) {
        Navigator.pushNamed(context, RoutesName.detailBook,
            arguments:
                DetailBookArgs(book: book, extensionModel: extensionModel));
      },
    );
  }

  Widget _noSearchResults() {
    return Center(
      child: const Text("search.noSearchResults").tr(args: [query]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_listBook.isNotEmpty) {
      return BooksGridWidget(
        onFetchListBook: (page) => onSearchBook(query, page),
        emptyWidget: _noSearchResults(),
        useFetch: false,
        useRefresh: false,
        initialBooks: _listBook,
      );
    }
    return const SizedBox();
  }
}
