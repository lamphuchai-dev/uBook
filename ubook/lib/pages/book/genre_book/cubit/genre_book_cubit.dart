import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/services/js_runtime.dart';

part 'genre_book_state.dart';

class GenreBookCubit extends Cubit<GenreBookState> {
  GenreBookCubit(
      {required this.extension,
      required this.genre,
      required JsRuntime jsRuntime})
      : _jsRuntime = jsRuntime,
        super(GenreBookInitial());

  final Extension extension;
  final Genre genre;
  final JsRuntime _jsRuntime;
  void onInit() {}

  Future<List<Book>> onGetListBook(int page) async {
    try {
      final result = await _jsRuntime.listBook(
          url: genre.url!,
          page: page,
          jsScript: extension.getHomeScript,
          extType: extension.metadata.type);
      return result;
    } catch (error) {
      // _logger.error(error, name: "onGetListBook");
    }
    return [];
  }
}
