import 'package:flutter/material.dart';
import 'package:h_book/data/models/book.dart';
import '../cubit/chapters_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chapters_page.dart';

class ChaptersView extends StatelessWidget {
  const ChaptersView({super.key,required this.book});
  final Book book;
  static const String routeName = '/chapters_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChaptersCubit(book:book)..onInit(),
      child: const ChaptersPage(),
    );
  }
}
