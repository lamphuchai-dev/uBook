import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/app/router/name_routes.dart';
import 'package:h_book/pages/book/media_settings/widgets/bottom_sheet.dart';

import '../cubit/read_book_cubit.dart';

class BottomBaseMenuWidget extends StatelessWidget {
  const BottomBaseMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: const Color(0xffDDDDDD).withOpacity(0.96),
          border: const Border(top: BorderSide(color: Color(0xffBABABA)))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          const Row(
            children: [
              Expanded(
                  child: Text(
                "Chương 4892 : Đại hỗn chiến",
                textAlign: TextAlign.center,
              )),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              IconButton(
                  onPressed: () {
                    context.read<ReadBookCubit>().onPreviousPage();
                  },
                  icon: const Icon(Icons.skip_previous)),
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: context.read<ReadBookCubit>().chaptersSlider,
                builder: (context, value, child) => Slider(
                  min: 0,
                  value: value.toDouble(),
                  max:
                      context.read<ReadBookCubit>().getTotalChapters.toDouble(),
                  onChanged: (value) => context
                      .read<ReadBookCubit>()
                      .onChangeChaptersSlider(value.toInt()),
                ),
              )),
              IconButton(
                  onPressed: () {
                    context.read<ReadBookCubit>().onNextPage();
                  },
                  icon: const Icon(Icons.skip_next)),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.read<ReadBookCubit>().onHideCurrentMenu();
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.format_list_bulleted)),
                IconButton(
                    onPressed: () {
                      context.read<ReadBookCubit>().onEnableMedia();
                    },
                    icon: const Icon(Icons.headphones)),
                IconButton(
                    onPressed: () async {
                      // Navigator.pushNamed(context, NameRoutes.mediaSettings);
                      
                    },
                    icon: const Icon(Icons.settings))
              ].expandedEqually().toList(),
            ),
          ),
        ],
      ),
    );
  }
}
