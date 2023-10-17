import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit()
      : super(const BottomNavigationBarState(indexSelected: 0));

  void onInit() {}

  void onChangeIndexSelected(int index) {
    emit(state.copyWith(indexSelected: index));
    test();
  }

  void test() async {
    //   final urls = List.generate(
    //           100,
    //           (index) =>
    //               "https://i33.ntcdntempv26.com/data/images/79466/1064326/003-a21b2ab.jpg?data=net")
    //       .toList();
    //   final dio = getIt<DioClient>();

    //   for (var i = 0; i < urls.length; i++) {
    //     dio
    //         .getWithConcurrent(
    //           urls[i],
    //           options: Options(
    //               headers: {"Referer": "https://www.nettruyenus.com"},
    //               responseType: ResponseType.bytes),
    //           onReceiveProgress: (p0, p1) {
    //             // print(p0);
    //           },
    //         )
    //         .then((res) => debugPrint('Response: id=$i -> ${res.runtimeType}'))
    //         .onError((e, s) => debugPrint('Response: id= $i,error: $e'));
    //   }
  }
}
