import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/pages/book/media_settings/widgets/text_to_speech_settings_widget.dart';

import '../cubit/read_book_cubit.dart';

class MediaMenuWidget extends StatelessWidget {
  const MediaMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: [
                GestureDetector(
                  onTap: context.read<ReadBookCubit>().onSkipPreviousMedia,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.skip_previous_rounded,
                        size: 20,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  onTap: context.read<ReadBookCubit>().onFastRewindMedia,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.fast_rewind_rounded,
                        size: 26,
                        color: Colors.white,
                      )),
                ),
                BlocBuilder<ReadBookCubit, ReadBookState>(
                  builder: (context, state) {
                    if (state is! ReadBookMedia) {
                      return const SizedBox();
                    }
                    final iconData = state.mediaStatus == MediaStatus.pause
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded;
                    return GestureDetector(
                      onTap: () {
                        if (state.mediaStatus == MediaStatus.pause) {
                          context.read<ReadBookCubit>().onPlayMedia();
                        } else {
                          context.read<ReadBookCubit>().onPauseMedia();
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Icon(
                            iconData,
                            size: 50,
                            color: Colors.white,
                          )),
                    );
                  },
                ),
                GestureDetector(
                  onTap: context.read<ReadBookCubit>().onFastForwardMedia,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.fast_forward_rounded,
                        size: 26,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  onTap: context.read<ReadBookCubit>().onSkipNextMedia,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.skip_next_rounded,
                        size: 20,
                        color: Colors.white,
                      )),
                ),
              ].expandedEqually().toList(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Text("fe")),
              IconButton(
                  onPressed: () {
                    context.read<ReadBookCubit>().onStopMedia();
                  },
                  icon: const RotatedBox(
                      quarterTurns: 2, child: Icon(Icons.power_settings_new))),
              IconButton(
                  onPressed: () async {
                    context.read<ReadBookCubit>().onPauseMedia();
                    // await context
                    //     .read<ReadBookCubit>()
                    //     .onHideCurrentMenu()
                    //     .then((value) {
                    //   showModalBottomSheet(
                    //     context: context,
                    //     isScrollControlled: true,
                    //     elevation: 0,
                    //     builder: (context) =>
                    //         const TextToSpeechSettingsWidget(),
                    //   );
                    // });
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      elevation: 0,
                      builder: (context) => const TextToSpeechSettingsWidget(),
                    );
                  },
                  icon: const Icon(Icons.settings))
            ].expandedEqually().toList(),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
