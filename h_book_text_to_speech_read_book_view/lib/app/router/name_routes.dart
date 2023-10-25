import 'package:h_book/pages/book/chapters/chapters.dart';
import 'package:h_book/pages/book/detail_book/detail_book.dart';
import 'package:h_book/pages/book/media_settings/media_settings.dart';
import 'package:h_book/pages/book/read_book/read_book.dart';
import 'package:h_book/pages/web_view/web_view.dart';

class NameRoutes {
  const NameRoutes._();
  static const detailBook = DetailBookView.routeName;
  static const chapters = ChaptersView.routeName;
  static const readBook = ReadBookView.routeName;
  static const mediaSettings = MediaSettingsView.routeName;
  static const webView = WebViewView.routeName;
}
