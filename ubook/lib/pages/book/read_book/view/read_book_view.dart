// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/database_service.dart';

import '../cubit/read_book_cubit.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView({super.key, required this.readBookArgs});
  static const String routeName = '/read_book_view';
  final ReadBookArgs readBookArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit(
          jsRuntime: getIt<ExtensionsService>().jsRuntime,
          extensionManager: getIt<ExtensionsService>(),
          readBookArgs: readBookArgs,
          databaseService: getIt<DatabaseService>())
        ..onInit(),
      child: const ReadBookPage(),
    );
  }
}

class ReadBookArgs {
  final Book book;
  final int readChapter;
  final List<Chapter> chapters;
  final bool fromBookmarks;
  final bool loadChapters;
  ReadBookArgs(
      {required this.book,
      this.readChapter = 0,
      required this.chapters,
      required this.fromBookmarks,
      required this.loadChapters});
}
