import 'package:flutter/material.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/js_runtime.dart';
import '../cubit/read_book_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView({super.key, required this.readBookArgs});
  static const String routeName = '/read_book_view';
  final ReadBookArgs readBookArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit(
          book: readBookArgs.book,
          jsRuntime: getIt<JsRuntime>(),
          databaseService: getIt<DatabaseService>(),
          extensionsService: getIt<ExtensionsService>())
        ..onInit(
            chapters: readBookArgs.chapters,
            initReadChapter: readBookArgs.readChapter),
      child: const ReadBookPage(),
    );
  }
}

class ReadBookArgs {
  Book book;
  int readChapter;
  List<Chapter> chapters;
  bool fromBookmarks;
  bool loadChapters;
  ReadBookArgs(
      {required this.book,
      this.readChapter = 0,
      required this.chapters,
      required this.fromBookmarks,
      required this.loadChapters});
}
