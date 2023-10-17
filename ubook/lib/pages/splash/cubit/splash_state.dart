// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  // final StatusType statusType;
  @override
  List<Object> get props => [];

  // SplashState copyWith({
  //   StatusType? statusType,
  // }) {
  //   return SplashState(
  //     statusType: statusType ?? this.statusType,
  //   );
  // }
}

class SplashStateInitial extends SplashState {
  const SplashStateInitial();
}

class LoadingLocalExts extends SplashState {
  const LoadingLocalExts();
}

class LoadedLocalExts extends SplashState {
  const LoadedLocalExts();
}

class LocalExtsEmpty extends SplashState {
  const LocalExtsEmpty();
}
