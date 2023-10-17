// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bottom_navigation_bar_cubit.dart';

class BottomNavigationBarState extends Equatable {
  const BottomNavigationBarState({required this.indexSelected});
  final int indexSelected;
  @override
  List<Object> get props => [indexSelected];

  BottomNavigationBarState copyWith({
    int? indexSelected,
  }) {
    return BottomNavigationBarState(
      indexSelected: indexSelected ?? this.indexSelected,
    );
  }
}
