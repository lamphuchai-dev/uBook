import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/extensions.dart';

import '../cubit/read_book_cubit.dart';

class TopBaseMenuWidget extends StatelessWidget {
  const TopBaseMenuWidget({super.key, required this.readBookCubit});
  final ReadBookCubit readBookCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final book = readBookCubit.book;
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Expanded(child: Text(book.name)),
                  IconButton(
                      onPressed: () {
                        readBookCubit.onEnableAutoScroll();
                      },
                      icon: const Icon(
                        Icons.swipe_down_alt_rounded,
                        size: 28,
                      )),
                  BlocSelector<ReadBookCubit, ReadBookState, bool>(
                    selector: (state) => state.book.bookmark,
                    builder: (context, bookmark) {
                      if (bookmark) {
                        return IconButton(
                            onPressed: () {
                              readBookCubit.onDeleteToBookmark();
                            },
                            icon: Icon(
                              Icons.bookmark_added_rounded,
                              color: colorScheme.primary,
                            ));
                      }
                      return IconButton(
                          onPressed: () {
                            readBookCubit.onAddToBookmark();
                          },
                          icon: const Icon(Icons.bookmark_add_rounded));
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
