import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/data/models/page_plugin.dart';
import 'package:h_book/data/models/plugin.dart';
import 'package:h_book/main.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(tabs: []));

  void onInit() async {
    emit(state.copyWith(tabs: getIt<BookPlugin>().homeTabs));
  }
}
