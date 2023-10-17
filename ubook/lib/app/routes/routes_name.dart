import 'package:ubook/pages/book/chapters/chapters.dart';
import 'package:ubook/pages/book/detail_book/detail_book.dart';
import 'package:ubook/pages/book/genre_book/genre_book.dart';
import 'package:ubook/pages/book/read_book/read_book.dart';
import 'package:ubook/pages/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:ubook/pages/home/home.dart';
import 'package:ubook/pages/install_extension/install_extension.dart';

class RoutesName {
  static const bottomNav = BottomNavigationBarView.routeName;
  static const home = HomeView.routeName;
  static const detailBook = DetailBookView.routeName;
  static const chaptersBook = ChaptersView.routeName;
  static const readBook = ReadBookView.routeName;
  static const installExt = InstallExtensionView.routeName;
  static const genreBook = GenreBookView.routeName;
}
