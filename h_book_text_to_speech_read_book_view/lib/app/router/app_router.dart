import 'package:flutter/material.dart';
import 'package:h_book/data/models/book.dart';
import 'package:h_book/pages/book/chapters/chapters.dart';
import 'package:h_book/pages/book/detail_book/detail_book.dart';
import 'package:h_book/pages/home/home.dart';
import 'package:h_book/pages/book/read_book/read_book.dart';
import 'package:h_book/pages/web_view/view/web_view_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:h_book/pages/book/media_settings/media_settings.dart';

class Routes {
  static const initialRoute = "/";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case HomeView.routeName:
        return PageTransition(
            settings: settings,
            child: const HomeView(),
            type: PageTransitionType.rightToLeft);
      case DetailBookView.routeName:
        assert(args != null && args is Book, "args is book");
        return PageTransition(
            settings: settings,
            child: DetailBookView(
              book: args as Book,
            ),
            type: PageTransitionType.rightToLeft);
      case ChaptersView.routeName:
        assert(args != null && args is Book, "args is book");
        return PageTransition(
            settings: settings,
            child: ChaptersView(
              book: args as Book,
            ),
            type: PageTransitionType.rightToLeft);

      // // case NameRoutes.readChapter:
      case "/":

        // assert(args != null && args is Book, "args is book");
        return PageTransition(
            settings: settings,
            child: const ReadBookView(),
            type: PageTransitionType.rightToLeft);

        // case MediaSettingsView.routeName:
        // return PageTransition(
        //     settings: settings,
        //     child: const MediaSettingsView(),
        //     type: PageTransitionType.rightToLeft);

      // case WebViewView.routeName:
      // return PageTransition(
      //     settings: settings,
      //     child: const WebViewView(),
      //     type: PageTransitionType.rightToLeft);

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
