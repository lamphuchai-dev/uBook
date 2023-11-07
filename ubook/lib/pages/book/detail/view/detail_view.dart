import 'package:flutter/material.dart';
import 'package:ubook/di/components/service_locator.dart';
import 'package:ubook/services/index.dart';
import '../cubit/detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_page.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.bookUrl});
  static const String routeName = '/detail_view';
  final String bookUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(
          bookUrl: bookUrl,
          extensionManager: getIt<ExtensionsService>(),
          databaseService: getIt<DatabaseService>(),
          jsRuntime: getIt<JsRuntime>()),
      child: const DetailPage(),
    );
  }
}
