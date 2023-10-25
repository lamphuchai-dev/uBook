// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chapters_cubit.dart';


class ChaptersState extends Equatable {
  const ChaptersState({
    required this.statusType,
    required this.chapters,
  });
  final StatusType statusType;
  final List<Chapter> chapters;
  @override
  List<Object> get props => [statusType, chapters];

  ChaptersState copyWith({
    StatusType? statusType,
    List<Chapter>? chapters,
  }) {
    return ChaptersState(
      statusType: statusType ?? this.statusType,
      chapters: chapters ?? this.chapters,
    );
  }
}
