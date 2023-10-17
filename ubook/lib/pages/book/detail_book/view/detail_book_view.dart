// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/data/models/book.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/extensions_service.dart';

import '../cubit/detail_book_cubit.dart';

import 'detail_book_page.dart';

class DetailBookView extends StatelessWidget {
  const DetailBookView({super.key, required this.args});
  final DetailBookArgs args;
  static const String routeName = '/detail_book_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBookCubit(
          book: args.book,
          extension: args.extensionModel,
          extensionManager: getIt<ExtensionsService>(),
          databaseService: getIt<DatabaseService>())
        ..onInit(),
      child: const DetailBookPage(),
    );
  }
}

class DetailBookArgs {
  final Book book;
  final Extension extensionModel;
  DetailBookArgs({
    required this.book,
    required this.extensionModel,
  });
}
