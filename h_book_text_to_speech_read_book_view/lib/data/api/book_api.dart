import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/utils/common.dart';
import 'package:html/parser.dart';

import 'data_test.dart';

class BookApi {
  final _dio = Dio();
  static const _logger = "BookApi";

  Future<String?> getBook() async {
    try {
      getBookDetail();

      // final url = "https://metruyencv.com/truyen/than-kiem-vo-dich/chuong-1";
      // final result = await _dio.get(url);
      // getBookDetail();
      // if (result.statusCode == 200) {
      //   return contentBook(result.data);
      // }
      return "";
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<String?> getBookDetail() async {
    try {
      final url = "https://metruyencv.com/truyen/than-kiem-vo-dich";
      final result = await _dio.get(
        url,
      );

      if (result.statusCode == 200) {
        return bookDetail(result.data);
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  String? contentBook(String stringHtml) {
    var document =
        parse(stringHtml.toString().replaceAll(RegExp(r"<!--|-->"), ''));
    final chapterContentDocument = document.getElementById("article");
    if (chapterContentDocument == null) return null;
    return chapterContentDocument.innerHtml
        .replaceAll(RegExp(r"<br><br>"), '\n\n')
        .replaceAllMapped(
          RegExp(r'<br>.*?<br>'),
          (match) => ' ',
        );
  }

  String? bookDetail(String stringHtml) {
    var document =
        parse(stringHtml.toString().replaceAll(RegExp(r"<!--|-->"), ''));
    final chapterContentDocument = document.querySelector('div[class="media"]');

    // var tmp =  document.querySelector(button[class = "btn btn-primary btn-md btn-shadow btn-block font-weight-semibold fz-16"])

    final numberChapter = chapterContentDocument
            ?.querySelector('ul[class="list-unstyled d-flex mb-4"]')
            ?.querySelectorAll('li[class="mr-5"]') ??
        [];
    for (var element in numberChapter) {
      // print(element.innerHtml);
      final text = element.querySelector('div[class=""]');
      final div = element.firstChild?.text;
      log(text!.text);
      log(div!);
    }
    // log(numberChapter.i.toString());
    // print(chapterContentDocument.text);
    return "";
  }

  void image() {
    // final image = document
    // .querySelector('div[class="nh-thumb nh-thumb--210 shadow"]')
    // ?.querySelector('img')
    // ?.attributes["src"];

    //  final numberChapter = chapterContentDocument
    //   ?.querySelector('div[class="font-weight-semibold h4 mb-1"]')!
    //   .text;
  }

  Future<void> getListStoryByType() async {
    try {
      // final response = await _dio
      //     .get("https://metruyencv.com/bang-xep-hang/thang/thinh-hanh");
      // response.statusCode.toString().log(tag: "$_logger ::: statusCode");

      // if (response.statusCode == 200) {
      //   await Common.storyByDocument(response.data);
      //   print("object");
      // }
      // await Common.storyByDocument(listStoryHTML);
    } catch (error) {
      error.toString().log(tag: "$_logger ::: getListStoryByType");
    }
  }
}
