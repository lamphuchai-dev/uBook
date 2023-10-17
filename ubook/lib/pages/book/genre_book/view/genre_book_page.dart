import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/widgets/book/books_grid_widget.dart';
import '../cubit/genre_book_cubit.dart';

class GenreBookPage extends StatefulWidget {
  const GenreBookPage({super.key});

  @override
  State<GenreBookPage> createState() => _GenreBookPageState();
}

class _GenreBookPageState extends State<GenreBookPage> {
  late GenreBookCubit _genreBookCubit;
  @override
  void initState() {
    _genreBookCubit = context.read<GenreBookCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: false, title: Text(_genreBookCubit.genre.title!)),
      body: BooksGridWidget(
        onFetchListBook: (page) {
          return _genreBookCubit.onGetListBook(page);
        },
        onTap: (book) {
          Navigator.pushNamed(context, RoutesName.detailBook,
              arguments: DetailBookArgs(
                  book: book, extensionModel: _genreBookCubit.extension));
        },
      ),
    );
  }
}
