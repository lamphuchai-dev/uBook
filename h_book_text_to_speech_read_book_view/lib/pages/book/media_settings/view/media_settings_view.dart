import 'package:flutter/material.dart';
import '../cubit/media_settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'media_settings_page.dart';

class MediaSettingsView extends StatelessWidget {
  const MediaSettingsView({super.key});
  static const String routeName = '/media_settings_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaSettingsCubit()..onInit(),
      child: const MediaSettingsPage(),
    );
  }
}
