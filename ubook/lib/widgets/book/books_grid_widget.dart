// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/data/models/book.dart';
import 'package:ubook/widgets/book/item_book.dart';
import 'package:ubook/widgets/loading_widget.dart';

typedef OnFetchListBook = Future<List<Book>> Function(int page);

class BooksGridWidget extends StatefulWidget {
  const BooksGridWidget(
      {super.key,
      this.onFetchListBook,
      this.emptyWidget,
      this.onChangeBooks,
      this.useFetch = true,
      this.useRefresh = true,
      this.initialBooks,
      this.listenBooks = false,
      this.onTap});
  final OnFetchListBook? onFetchListBook;
  final Widget? emptyWidget;
  final ValueChanged<List<Book>>? onChangeBooks;
  final bool useFetch;
  final List<Book>? initialBooks;
  final bool useRefresh;
  final bool listenBooks;
  final ValueChanged<Book>? onTap;

  @override
  State<BooksGridWidget> createState() => _BooksGridWidgetState();
}

class _BooksGridWidgetState extends State<BooksGridWidget> {
  int _page = 1;
  List<Book> _listBook = [];
  bool _isLoading = false;

  bool _isLoadMore = false;

  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset >
              _scrollController.position.maxScrollExtent - 200) &&
          !_isLoadMore &&
          widget.useFetch) {
        _onLoadMore();
      }
    });

    if (!widget.useFetch) {
      _listBook = widget.initialBooks ?? [];
    } else {
      _onLoading();
    }
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _isLoading = true;
    });
    _page = 1;
    _listBook = await widget.onFetchListBook!.call(_page);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onLoadMore() async {
    setState(() {
      _isLoadMore = true;
    });
    try {
      _page++;
      final list = await widget.onFetchListBook!.call(_page);
      if (list.isNotEmpty) {
        setState(() {
          _listBook.addAll(list);
        });
        widget.onChangeBooks?.call(_listBook);
      }
    } catch (error) {}
    setState(() {
      _isLoadMore = false;
    });
  }

  ({int minItem, int maxItem, double heightItem, int crossAxisCount}) _get(
      int countItem) {
    const minWidth = 90;
    const maxWidth = 180;
    const heightFot = 40;

    final width = context.width - Dimens.horizontalPadding * 2;
    final minItem = width ~/ maxWidth;
    final maxItem = width ~/ minWidth;
    final heightItem = (width / countItem) * 1.45 + heightFot;
    return (
      minItem: minItem,
      maxItem: maxItem,
      heightItem: heightItem,
      crossAxisCount: countItem
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.useFetch) {
      return const LoadingWidget();
    }

    if (_listBook.isEmpty) {
      return widget.emptyWidget ?? const _EmptyBooks();
    }

    final girdConfig = _get(3);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.horizontalPadding,
      ),
      child: _refreshWidget(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: girdConfig.crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisExtent: girdConfig.heightItem,
                  mainAxisSpacing: 8),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final book = _listBook[index];
                  return ItemBook(
                    book: book,
                    onTap: () => widget.onTap?.call(book),
                    onLongTap: () {},
                  );
                },
                childCount: _listBook.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _isLoadMore
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SpinKitThreeBounce(
                        color: context.colorScheme.primary,
                        size: 25.0,
                      ),
                    )
                  : const SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant BooksGridWidget oldWidget) {
    if (widget.initialBooks != oldWidget.initialBooks) {
      setState(() {
        _listBook = widget.initialBooks!;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _refreshWidget({required Widget child}) {
    if (widget.useRefresh) {
      return RefreshIndicator(
        onRefresh: () async {
          _onLoading();
        },
        child: child,
      );
    }
    return child;
  }
}

class _EmptyBooks extends StatelessWidget {
  const _EmptyBooks({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Center(
      child: Text(
        "Không có dữ liệu hiện thị",
        style: textTheme.bodyLarge,
      ),
    );
  }
}
