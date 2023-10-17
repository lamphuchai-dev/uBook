import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ubook/app/config/app_type.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/context_extension.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/pages/book/chapters/chapters.dart';
import 'package:ubook/widgets/cache_network_image.dart';
import 'package:ubook/widgets/widgets.dart';
import '../cubit/detail_book_cubit.dart';
import '../widgets/widgets.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late DetailBookCubit _detailBookCubit;

  final collapsedBarHeight = kToolbarHeight;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isCollapsed = ValueNotifier(false);
  final ValueNotifier<double> _offset = ValueNotifier(0.0);
  @override
  void initState() {
    _detailBookCubit = context.read<DetailBookCubit>();

    // SystemUtils.setSystemNavigationBarColor(context.colorScheme.surface);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final coverUrl = _detailBookCubit.state.book.cover;
    final book = _detailBookCubit.state.book;

    final expandedBarHeight =
        (context.height * 0.3) < 250 ? 250.0 : (context.height * 0.3);
    const paddingAppBar = 16.0;

    return Scaffold(
      body: NotificationListener(
        onNotification: (notification) {
          if (_scrollController.hasClients &&
              _scrollController.offset <=
                  (expandedBarHeight - collapsedBarHeight)) {
            _offset.value = _scrollController.offset / (expandedBarHeight);
          }

          if (_scrollController.hasClients &&
              _scrollController.offset >
                  (expandedBarHeight - collapsedBarHeight) &&
              !isCollapsed.value) {
            isCollapsed.value = true;
          } else if (!(_scrollController.hasClients &&
                  _scrollController.offset >
                      (expandedBarHeight - collapsedBarHeight)) &&
              isCollapsed.value) {
            isCollapsed.value = false;
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: expandedBarHeight,
              collapsedHeight: collapsedBarHeight,
              centerTitle: false,
              pinned: true,
              title: ValueListenableBuilder(
                valueListenable: _offset,
                builder: (context, value, child) => Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Text(book.name),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
              elevation: 0,
              leading: const BackButton(
                color: Colors.white,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                        child: BlurredBackdropImage(
                      url: coverUrl,
                    )),
                    Positioned.fill(
                      top: kToolbarHeight,
                      bottom: paddingAppBar,
                      right: 0,
                      left: 0,
                      child: SafeArea(
                        child: Row(
                          children: [
                            Gaps.wGap16,
                            Flexible(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                clipBehavior: Clip.hardEdge,
                                child: CacheNetWorkImage(
                                  coverUrl,
                                ),
                              ),
                            ),
                            Gaps.wGap12,
                            Expanded(
                                flex: 3,
                                child: BlocBuilder<DetailBookCubit,
                                    DetailBookState>(
                                  builder: (context, state) {
                                    final book = state.book;
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              book.name,
                                              style: textTheme.titleLarge,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Text(
                                            book.author,
                                            maxLines: 2,
                                          ),
                                          Text(book.bookStatus),
                                          Text(book.totalChapters == 0
                                              ? ""
                                              : book.totalChapters.toString()),
                                        ]);
                                  },
                                )),
                            Gaps.wGap16,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<DetailBookCubit, DetailBookState>(
                buildWhen: (previous, current) =>
                    previous.statusType != current.statusType,
                builder: (context, state) {
                  final book = state.book;
                  switch (state.statusType) {
                    case StatusType.loading:
                      return SizedBox(
                          height: 200,
                          child: SpinKitWaveSpinner(
                            color: colorScheme.primary,
                          ));
                    case StatusType.loaded:
                      return BookDetail(
                        book: book,
                        extension: _detailBookCubit.extension,
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<DetailBookCubit, DetailBookState>(
        buildWhen: (previous, current) =>
            previous.statusType != current.statusType,
        builder: (context, state) {
          final run = state.statusType == StatusType.loaded;
          return SlideTransitionAnimation(
            runAnimation: run,
            type: AnimationType.bottomToTop,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimens.horizontalPadding, vertical: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: colorScheme.background,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _detailBookCubit.actionBookmark();
                      },
                      child: BlocBuilder<DetailBookCubit, DetailBookState>(
                        builder: (context, state) {
                          return Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(Dimens.radius)),
                            alignment: Alignment.center,
                            child: state.isBookmark
                                ? Icon(
                                    Icons.bookmark_added_rounded,
                                    size: 30,
                                    color: colorScheme.primary,
                                  )
                                : const Icon(
                                    Icons.bookmark_add_rounded,
                                    size: 30,
                                  ),
                          );
                        },
                      ),
                    ),
                    Gaps.wGap8,
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.chaptersBook,
                            arguments: ChaptersBookArgs(
                                book: _detailBookCubit.state.book,
                                extensionModel: _detailBookCubit.extension));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(Dimens.radius)),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.menu_book_rounded,
                          size: 30,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
