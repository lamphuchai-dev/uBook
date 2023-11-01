// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'discovery_cubit.dart';

enum ExtensionStatus { init, loading, loaded, noInstall, error }

abstract class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object> get props => [];
}

class DiscoveryStateInitial extends DiscoveryState {}

class LoadingExtensionState extends DiscoveryState {}

class LoadedExtensionState extends DiscoveryState {
  const LoadedExtensionState({required this.extension});
  final Extension extension;

  @override
  List<Object> get props => [extension];
}

class ExtensionNoInstallState extends DiscoveryState {}
