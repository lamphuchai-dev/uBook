import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/services/js_runtime.dart';
import 'package:ubook/utils/directory_utils.dart';

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
  late JsRuntime _jsRuntime;
  void onInit() {}

  Future<List<Book>> onGetListBook(int page) async {
    try {
      final jsScript = DirectoryUtils.getJsScriptByPath(extension.script.home);
      final result = await _jsRuntime.listBook(
          url: genre.url!,
          page: page,
          jsScript: jsScript,
          extType: extension.metadata.type);
      return result;
    } catch (error) {
      // _logger.error(error, name: "onGetListBook");
    }
    return [];
  }
}
