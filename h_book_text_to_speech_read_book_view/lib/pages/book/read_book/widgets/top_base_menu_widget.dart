import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/pages/book/read_book/cubit/read_book_cubit.dart';

class TopBaseMenuWidget extends StatelessWidget {
  const TopBaseMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      decoration: BoxDecoration(
          color: const Color(0xffDDDDDD).withOpacity(0.96),
          border: const Border(bottom: BorderSide(color: Color(0xffBABABA)))),
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
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Expanded(child: Text("Thanh liên chi đỉnh")),
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
