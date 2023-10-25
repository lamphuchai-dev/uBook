import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/router/name_routes.dart';
import '../cubit/detail_book_cubit.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late DetailBookCubit _detailBookCubit;
  @override
  void initState() {
    _detailBookCubit = context.read<DetailBookCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBookCubit, DetailBookState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(centerTitle: true, title: const Text("Detail book")),
            body: Column(children: [
              Center(
                child: Text(state.book.chapterCount.toString()),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NameRoutes.chapters,
                        arguments: state.book);
                  },
                  child: const Text("Chapters"))
            ]));
      },
    );
  }
}
