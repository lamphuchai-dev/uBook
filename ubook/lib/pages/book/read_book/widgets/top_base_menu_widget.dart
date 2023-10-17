import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/data/models/book.dart';

import '../cubit/read_book_cubit.dart';

class TopBaseMenuWidget extends StatelessWidget {
  const TopBaseMenuWidget({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      // height: 110,
      decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border(bottom: BorderSide(color: colorScheme.surface))),
      child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        // _readBookCubit.onSkipPrevious();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Expanded(child: Text(book.name)),
                  IconButton(
                      onPressed: () {
                        context.read<ReadBookCubit>().onEnableAutoScroll();
                      },
                      icon: const Icon(
                        Icons.swipe_down_alt_rounded,
                        size: 28,
                      )),
                  IconButton(
                      onPressed: () {
                        // _readBookCubit.onSkipNext();
                      },
                      icon: const Icon(Icons.more_vert)),
                ],
              )
            ],
          )),
    );
  }
}
