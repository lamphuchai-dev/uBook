// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/data/models/extension.dart';
import 'package:ubook/data/models/genre.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/extensions_service.dart';

import '../cubit/genre_book_cubit.dart';
import 'genre_book_page.dart';

class GenreBookView extends StatelessWidget {
  const GenreBookView({super.key, required this.arg});
  static const String routeName = '/genre_book_view';
  final GenreBookArg arg;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenreBookCubit(
          extension: arg.extension,
          genre: arg.genre,
          jsRuntime: getIt<ExtensionsService>().jsRuntime)
        ..onInit(),
      child: const GenreBookPage(),
    );
  }
}

class GenreBookArg {
  final Extension extension;
  final Genre genre;
  GenreBookArg({
    required this.extension,
    required this.genre,
  });
}
