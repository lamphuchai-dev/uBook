import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tab_home_state.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  TabHomeCubit() : super(TabHomeInitial());

  void onInit() {}
}
