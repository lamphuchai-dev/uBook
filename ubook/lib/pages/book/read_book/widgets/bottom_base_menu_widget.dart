import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/app/extensions/extensions.dart';
import 'package:ubook/pages/book/read_book/cubit/read_book_cubit.dart';

class BottomBaseMenuWidget extends StatefulWidget {
  const BottomBaseMenuWidget({super.key});

  @override
  State<BottomBaseMenuWidget> createState() => _BottomBaseMenuWidgetState();
}

class _BottomBaseMenuWidgetState extends State<BottomBaseMenuWidget> {
  late ReadBookCubit _readBookCubit;
  @override
  void initState() {
    _readBookCubit = context.read<ReadBookCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border(top: BorderSide(color: colorScheme.background))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: _readBookCubit.readChapter,
                builder: (context, value, child) {
                  if (value == null) const SizedBox();
                  return Text(
                    value!.title,
                    textAlign: TextAlign.center,
                  );
                },
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
                valueListenable: _readBookCubit.readChapter,
                builder: (context, value, child) => Slider(
                  min: 0,
                  value: value?.index == null ? 0 : value!.index.toDouble(),
                  max: (_readBookCubit.chapters.length - 1).toDouble(),
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
                      // context.read<ReadBookCubit>().onEnableMedia();
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
