import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/extension.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/pages/home/widgets/genre_widget.dart';
import 'package:ubook/pages/home/widgets/widgets.dart';
import 'package:ubook/widgets/widgets.dart';

import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Widget body = const SizedBox();
        Widget title = const SizedBox();
        List<Widget>? actions = [];
        if (state is LoadingExtensionState || state is HomeStateInitial) {
          body = const LoadingWidget();
        } else if (state is ExtensionNoInstallState) {
          body = SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.extension_off_rounded,
                    size: 100,
                  ),
                  Gaps.hGap16,
                  const Text("Chưa có tiện ích nào được cài đặt"),
                  Gaps.hGap16,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.installExt);
                      },
                      child: const Text("Cài đặt tiện tích"))
                ]),
          );
          title = const Text("Tiện ích");
        } else if (state is LoadedExtensionState) {
          body = _extReady(state.extension);
          actions = [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchBookDelegate(
                          onSearchBook: _homeCubit.onSearchBook,
                          extensionModel: state.extension));
                },
                icon: const Icon(Icons.search_rounded))
          ];
          title = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                builder: (context) => SelectExtensionBottomSheet(
                  extensions: _homeCubit.extensionManager.getExtensions,
                  exceptionPrimary: state.extension,
                  onSelected: (ext) {
                    _homeCubit.onChangeExtensions(ext);
                  },
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: Text(state.extension.metadata.name)),
                Gaps.wGap8,
                const Icon(
                  Icons.expand_more_rounded,
                  size: 26,
                )
              ],
            ),
          );
        }

        return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: title,
              actions: actions,
            ),
            body: body);
      },
    );
  }

  Widget _extReady(Extension extension) {
    List<Tab> tabItems = extension.metadata.tabsHome
        .map(
          (e) => Tab(
            text: e.title,
          ),
        )
        .toList();
    List<Widget> tabChildren = extension.metadata.tabsHome
        .map(
          (tabHome) => KeepAliveWidget(
            child: BooksGridWidget(
              onFetchListBook: (page) {
                return _homeCubit.onGetListBook(tabHome.url, page);
              },
              onTap: (book) {
                Navigator.pushNamed(context, RoutesName.detailBook,
                    arguments:
                        DetailBookArgs(book: book, extensionModel: extension));
              },
            ),
          ),
        )
        .toList();
    if (extension.script.genre != null) {
      tabItems.add(const Tab(
        text: "Thể loại",
      ));
      tabChildren.add(KeepAliveWidget(
          child: GenreWidget(
        onFetch: _homeCubit.onGetListGenre,
        extension: extension,
      )));
    }
    return DefaultTabController(
      length: tabItems.length,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                tabs: tabItems),
            Expanded(child: TabBarView(children: tabChildren))
          ],
        ),
      ),
    );
  }
}
