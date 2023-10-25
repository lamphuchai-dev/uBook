import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chapters_cubit.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late ChaptersCubit _chaptersCubit;
  @override
  void initState() {
    _chaptersCubit = context.read<ChaptersCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Text(
            _chaptersCubit.book.name,
            style: textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          )),
      body:
          BlocBuilder<ChaptersCubit, ChaptersState>(builder: (context, state) {
        switch (state.statusType) {
          case StatusType.loading:
            return SpinKitFadingCube(
              color: colorScheme.primary,
              size: 50.0,
            );

          case StatusType.success:
            return ListView.builder(
              itemCount: state.chapters.length,
              itemBuilder: (context, index) {
                final chapter = state.chapters[index];
                return ListTile(
                  title: Text(chapter.name),
                );
              },
            );
          default:
            return const SizedBox();
        }
      }),
    );
  }
}
