// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

enum ExtensionStatus { init, loading, loaded, noInstall, error }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeStateInitial extends HomeState {}

class LoadingExtensionState extends HomeState {}

class LoadedExtensionState extends HomeState {
  const LoadedExtensionState({required this.extension});
  final Extension extension;

  @override
  List<Object> get props => [extension];
}

class ExtensionNoInstallState extends HomeState {}
