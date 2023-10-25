import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/extensions/extensions.dart';

import '../cubit/read_book_cubit.dart';

class AutoScrollMenuWidget extends StatelessWidget {
  const AutoScrollMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xffDDDDDD).withOpacity(0.96);

    return Container(
      margin: const EdgeInsets.only(right: 24, left: 16),
      height: context.height * 0.6,
      width: 30,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: backgroundColor, borderRadius: BorderRadius.circular(4)),
            child: const Text(
              "269",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(20))),
            child: RotatedBox(
                quarterTurns: 1,
                child: BlocBuilder<ReadBookCubit, ReadBookState>(
                  builder: (context, state) {
                    if (state is ReadBookAutoScroll) {
                      return Slider(
                        min: 5,
                        max: 40,
                        onChanged:
                            context.read<ReadBookCubit>().onChangeTimerScroll,
                        value: state.timerScroll,
                      );
                    }
                    return const SizedBox();
                  },
                )),
          )),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<ReadBookCubit, ReadBookState>(
            buildWhen: (previous, current) {
              return true;
            },
            builder: (context, state) {
              if (state is! ReadBookAutoScroll) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () {
                  if (state.scrollStatus == AutoScrollStatus.pause) {
                    context.read<ReadBookCubit>().onPlayAutoScroll();
                  } else {
                    context.read<ReadBookCubit>().onPauseAutoScroll();
                  }
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: Icon(state.scrollStatus == AutoScrollStatus.pause
                      ? Icons.play_arrow
                      : Icons.pause),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              context.read<ReadBookCubit>().onCloseAutoScroll();
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const Icon(
                Icons.circle,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
