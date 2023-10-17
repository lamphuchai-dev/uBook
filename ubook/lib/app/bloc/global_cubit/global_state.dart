part of 'global_cubit.dart';

class GlobalState extends Equatable {
  const GlobalState({required this.themeMode});
  final ThemeMode themeMode;

  GlobalState copyWith({
    ThemeMode? themeMode,
  }) {
    return GlobalState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];
}
