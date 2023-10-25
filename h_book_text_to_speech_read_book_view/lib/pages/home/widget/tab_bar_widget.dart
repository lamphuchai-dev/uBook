// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:h_book/app/constants/app_assets.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/data/models/book.dart';
import 'package:h_book/data/models/page_plugin.dart';
import 'package:h_book/pages/book/detail_book/view/detail_book_view.dart';
import 'package:h_book/utils/base_fetch.dart';
import 'package:h_book/utils/browser_headless_fetch.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key, required this.pagePlugin});
  final PagePlugin pagePlugin;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with AutomaticKeepAliveClientMixin {
  BaseFetch? _headLessBrowser;
  StreamSubscription? _streamSubscription;

  List<Book> _books = [];
  bool _isLoadMore = false;
  bool _isLoading = false;

  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset >
              _scrollController.position.maxScrollExtent - 200) &&
          !_isLoadMore) {
        onLoadMore();
      }
    });
    _headLessBrowser = FetchBrowserHeadlessPage<Book>(
        pagePlugin: widget.pagePlugin, modelName: "Book");
    _streamSubscription = _headLessBrowser?.stream.listen((event) {
      if (event is HeadLessBrowserValues<Book>) {
        "Status ::: ${event.status}, books : ${event.values?.length}"
            .log(tag: "StatusHeadLessBrowser");
        switch (event.status) {
          case StatusHeadLessBrowser.loadingSuccess:
            _books = event.values ?? [];

            sortBook();
            break;
          case StatusHeadLessBrowser.loadAddSuccess:
          case StatusHeadLessBrowser.loadMoreSuccess:
            _books.addAll(event.values ?? []);

            sortBook();

            break;
          case StatusHeadLessBrowser.error:
            break;
          default:
            break;
        }
      }
    });
    _headLessBrowser?.onInit();
    _headLessBrowser?.onFetch();
    _isLoading = true;
    _isLoadMore = true;

    super.initState();
  }

  void sortBook() {
    Map<String, Book> _mapBooks = {};
    for (var book in _books) {
      if (_mapBooks[book.name] == null) {
        _mapBooks[book.name] = book;
      }
    }
    _books = _mapBooks.values.toList();

    setState(() {
      _isLoadMore = false;
      _isLoading = false;
    });
  }

  void refresh() {
    _headLessBrowser?.onFetch();
  }

  void onLoadMore() {
    setState(() {
      _isLoadMore = true;
    });
    _headLessBrowser?.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = context.colorScheme;

    if (_isLoading) {
      return SpinKitFadingCube(
        color: colorScheme.primary,
        size: 50.0,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: context.height * 0.3,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 0
                ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final book = _books[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailBookView.routeName,
                        arguments: book);
                  },
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: book.poster,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              AppAssets.backgroundBook,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              AppAssets.backgroundBook,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                        SizedBox(
                          height: 60,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  book.name,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Center(
                                child: Text(
                                  book.authorName,
                                  style: const TextStyle(fontSize: 9),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: _books.length,
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoadMore
                ? SpinKitThreeBounce(
                    color: colorScheme.primary,
                    size: 25.0,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _headLessBrowser?.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
