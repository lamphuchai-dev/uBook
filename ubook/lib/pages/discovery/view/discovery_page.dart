import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/extension.dart';

import 'package:ubook/widgets/widgets.dart';

import '../cubit/discovery_cubit.dart';
import '../widgets/genre_widget.dart';
import '../widgets/widgets.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  late DiscoveryCubit _discoveryCubit;
  @override
  void initState() {
    _discoveryCubit = context.read<DiscoveryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        Widget body = const SizedBox();
        Widget title = const SizedBox();
        List<Widget>? actions = [];
        if (state is LoadingExtensionState || state is DiscoveryStateInitial) {
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
          if (state.extension.script.search != null) {
            actions = [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SearchBookDelegate(
                            onSearchBook: _discoveryCubit.onSearchBook,
                            extensionModel: state.extension));
                  },
                  icon: const Icon(Icons.search_rounded))
            ];
          }
          Widget leadingIcon() {
            if (state.extension.metadata.icon == "") {
              return const SizedBox();
            }
            try {
              final file = File(state.extension.metadata.icon);
              return Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Image.file(file));
            } catch (e) {
              return const SizedBox();
            }
          }

          title = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                builder: (context) => SelectExtensionBottomSheet(
                  extensions: _discoveryCubit.extensionManager.getExtensions,
                  exceptionPrimary: state.extension,
                  onSelected: (ext) {
                    _discoveryCubit.onChangeExtensions(ext);
                  },
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leadingIcon(),
                Gaps.wGap8,
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
              key: ValueKey(tabHome.title),
              onFetchListBook: (page) {
                return _discoveryCubit.onGetListBook(tabHome.url, page);
              },
              onTap: (book) {
                // Navigator.pushNamed(context, RoutesName.detail,
                //     arguments:
                //         DetailBookArgs(book: book, extensionModel: extension));

                Navigator.pushNamed(context, RoutesName.detail,
                    arguments: book.bookUrl);
              },
            ),
          ),
        )
        .toList();
    if (extension.script.genre != null) {
      tabItems.add(Tab(
        text: "common.genre".tr(),
      ));
      tabChildren.add(KeepAliveWidget(
          child: GenreWidget(
        onFetch: _discoveryCubit.onGetListGenre,
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
