// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({required this.tabs});

  final List<PagePlugin> tabs;

  @override
  List<Object> get props => [tabs];

  HomeState copyWith({
    List<PagePlugin>? tabs,
  }) {
    return HomeState(
      tabs: tabs ?? this.tabs,
    );
  }
}
