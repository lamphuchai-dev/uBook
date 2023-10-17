// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'install_extension_cubit.dart';

class InstallExtensionState extends Equatable {
  const InstallExtensionState(
      {required this.installedExts,
      required this.notInstalledExts,
      required this.statusType});
  final List<Extension> installedExts;
  final List<Metadata> notInstalledExts;
  final StatusType statusType;

  @override
  List<Object> get props => [installedExts, notInstalledExts, statusType];

  InstallExtensionState copyWith({
    List<Extension>? installedExts,
    List<Metadata>? notInstalledExts,
    StatusType? statusType,
  }) {
    return InstallExtensionState(
      installedExts: installedExts ?? this.installedExts,
      notInstalledExts: notInstalledExts ?? this.notInstalledExts,
      statusType: statusType ?? this.statusType,
    );
  }
}
