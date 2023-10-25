// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'install_extension_cubit.dart';

class InstallExtensionState extends Equatable {
  const InstallExtensionState({
    required this.installedExts,
    required this.notInstalledExts,
    required this.statusInstalled,
    required this.statusAllExtension,
  });
  final List<Extension> installedExts;
  final List<Metadata> notInstalledExts;
  final StatusType statusInstalled;
  final StatusType statusAllExtension;

  @override
  List<Object> get props =>
      [installedExts, notInstalledExts, statusInstalled, statusAllExtension];

  InstallExtensionState copyWith(
      {List<Extension>? installedExts,
      List<Metadata>? notInstalledExts,
      StatusType? statusType,
      StatusType? statusInstalled,
      StatusType? statusAllExtension}) {
    return InstallExtensionState(
      installedExts: installedExts ?? this.installedExts,
      notInstalledExts: notInstalledExts ?? this.notInstalledExts,
      statusInstalled: statusInstalled ?? this.statusInstalled,
      statusAllExtension: statusAllExtension ?? this.statusAllExtension,
    );
  }
}
