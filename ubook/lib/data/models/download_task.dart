// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'download_task.g.dart';

enum DownloadStatus { init, wait, downloading, complete, cannel }

@Collection()
class DownloadTask {
  final Id? id;
  final int bookId;
  @Enumerated(EnumType.ordinal)
  final DownloadStatus status;
  final int totalChapterDownload;
  final int totalDownloaded;
  final DateTime updateAt;

  DownloadTask(
      {this.id,
      required this.bookId,
      required this.status,
      required this.totalChapterDownload,
      required this.totalDownloaded,
      required this.updateAt});

  DownloadTask copyWith(
      {Id? id,
      int? bookId,
      DownloadStatus? status,
      int? totalChapterDownload,
      int? totalDownloaded,
      DateTime? updateAt}) {
    return DownloadTask(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        status: status ?? this.status,
        totalChapterDownload: totalChapterDownload ?? this.totalChapterDownload,
        totalDownloaded: totalDownloaded ?? this.totalDownloaded,
        updateAt: updateAt ?? this.updateAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'status': status.name,
      'totalChapterDownload': totalChapterDownload,
      'totalDownloaded': totalDownloaded,
    };
  }

  factory DownloadTask.fromMap(Map<String, dynamic> map) {
    return DownloadTask(
        id: map['id'],
        bookId: map['bookId'] as int,
        status: DownloadStatus.values.firstWhere(
            (el) => el.name == map['status'],
            orElse: () => DownloadStatus.wait),
        totalChapterDownload: map['totalChapterDownload'] ?? 0,
        totalDownloaded: map['totalDownloaded'] ?? 0,
        updateAt: map["updateAt"]);
  }

  String toJson() => json.encode(toMap());

  factory DownloadTask.fromJson(String source) =>
      DownloadTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DownloadTask(id: $id, bookId: $bookId, status: $status, totalChapterDownload: $totalChapterDownload, totalDownloaded: $totalDownloaded)';
  }

  @override
  bool operator ==(covariant DownloadTask other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bookId == bookId &&
        other.status == status &&
        other.totalChapterDownload == totalChapterDownload &&
        other.totalDownloaded == totalDownloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookId.hashCode ^
        status.hashCode ^
        totalChapterDownload.hashCode ^
        totalDownloaded.hashCode;
  }
}
