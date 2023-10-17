import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/database_service.dart';
import '../cubit/bookmarks_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bookmarks_page.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});
  static const String routeName = '/bookmarks_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookmarksCubit(databaseService: getIt<DatabaseService>())..onInit(),
      child: const BookmarksPage(),
    );
  }
}
