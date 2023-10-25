import 'package:flutter/material.dart';
import 'package:h_book/data/models/json_me.dart';
import 'package:h_book/main.dart';
import 'package:h_book/services/text_to_speech_service.dart';
import '../cubit/read_book_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView({super.key});
  static const String routeName = '/read_book_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit(
          book: book, textToSpeechService: getIt<TextToSpeechService>())
        ..onInit(),
      child: const ReadBookPage(),
    );
  }
}
