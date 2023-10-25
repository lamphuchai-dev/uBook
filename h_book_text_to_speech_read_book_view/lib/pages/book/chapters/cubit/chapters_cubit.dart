import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/data/models/book.dart';
import 'package:h_book/data/models/chapter.dart';
import 'package:h_book/data/models/plugin.dart';
import 'package:h_book/main.dart';
import 'package:h_book/utils/base_fetch.dart';
import 'package:h_book/utils/browser_headless_fetch.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit({required this.book})
      : super(const ChaptersState(chapters: [], statusType: StatusType.init));

  final Book book;

  BaseFetch? _headLessBrowser;
  StreamSubscription? _streamSubscription;
  void onInit() async {
    final host = getIt<BookPlugin>().info.source;
    final pagePlugin =
        getIt<BookPlugin>().pages[1].copyWith(url: "$host/${book.link}");
    _headLessBrowser = FetchBrowserHeadlessPage<Chapter>(
        pagePlugin: pagePlugin, modelName: "Chapter");
    _streamSubscription = _headLessBrowser?.stream.listen((event) {
      if (event is HeadLessBrowserValues<Chapter>) {
        "Status ::: ${event.status}, books : ${event.values?.length}"
            .log(tag: "StatusHeadLessBrowser :: ChaptersCubit");
        switch (event.status) {
          case StatusHeadLessBrowser.loadingSuccess:
            emit(state.copyWith(
                chapters: event.values, statusType: StatusType.success));
            break;
          case StatusHeadLessBrowser.loadAddSuccess:
          case StatusHeadLessBrowser.loadMoreSuccess:
            break;
          case StatusHeadLessBrowser.error:
            break;
          default:
            break;
        }
      }
    });

    await _headLessBrowser?.onInit();
    await _headLessBrowser?.onFetch();
    emit(state.copyWith(statusType: StatusType.loading));
  }

  @override
  Future<void> close() {
    _headLessBrowser?.dispose();
    _streamSubscription?.cancel();
    return super.close();
  }
}


// function getBooksByStringData(dataString) {try {var jsonData = JSON.parse(JSON.stringify(dataString));var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count});});return {"books":books,"nextPage":nextPage};}catch (error) {return null;}}