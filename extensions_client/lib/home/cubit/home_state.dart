// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({required this.result, required this.log});
  final String result;
  final List<LogModel> log;

  @override
  List<Object?> get props => [result, log];

  HomeState copyWith({
    String? result,
    List<LogModel>? log,
  }) {
    return HomeState(
      result: result ?? this.result,
      log: log ?? this.log,
    );
  }
}

class LogModel {
  final DateTime dateTime;
  final String log;
  LogModel({
    required this.dateTime,
    required this.log,
  });
}
