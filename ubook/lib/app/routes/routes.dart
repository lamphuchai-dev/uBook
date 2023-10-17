import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/pages/book/genre_book/genre_book.dart';
import 'package:ubook/pages/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/pages/book/chapters/chapters.dart';
import 'package:ubook/pages/book/read_book/read_book.dart';
import 'package:ubook/pages/install_extension/install_extension.dart';
import 'package:ubook/pages/splash/splash.dart';

class Routes {
  static const initialRoute = "/";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case initialRoute:
        return PageTransition(
            settings: settings,
            child: const SplashView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.bottomNav:
        return PageTransition(
            settings: settings,
            child: const BottomNavigationBarView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.installExt:
        return PageTransition(
            settings: settings,
            child: const InstallExtensionView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.detailBook:
        assert(args != null && args is DetailBookArgs,
            "args must be DetailBookArgs");
        return PageTransition(
            settings: settings,
            child: DetailBookView(
              args: args as DetailBookArgs,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.chaptersBook:
        assert(args != null && args is ChaptersBookArgs, "args must be Book");
        return PageTransition(
            settings: settings,
            child: ChaptersView(
              args: args as ChaptersBookArgs,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.readBook:
        assert(args != null && args is ReadBookArgs, "args must be Book");
        return PageTransition(
            settings: settings,
            child: ReadBookView(
              readBookArgs: args as ReadBookArgs,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.genreBook:
        assert(args != null && args is GenreBookArg, "args must be Book");
        return PageTransition(
            settings: settings,
            child: GenreBookView(
              arg: args as GenreBookArg,
            ),
            type: PageTransitionType.rightToLeft);

      default:
        return _errRoute();
    }
  }

  static Route<dynamic> _errRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("No route")),
              body: const Center(
                child: Text("no route"),
              ),
            ));
  }
}
