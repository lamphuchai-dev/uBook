import 'package:flutter/material.dart';
import 'package:ubook/app/constants/dimens.dart';
import 'package:ubook/app/constants/gaps.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/app/routes/routes_name.dart';
import 'package:ubook/data/models/models.dart';
import 'package:ubook/pages/book/genre_book/genre_book.dart';
import 'package:ubook/widgets/book/item_book.dart';
import 'package:ubook/widgets/widgets.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({super.key, required this.book, required this.extension});
  final Book book;
  final Extension extension;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.hGap8,
          _genreBook(context),
          _description(),
          if (book.recommended != null) ...[
            Gaps.hGap16,
            Text(
              "Cùng thể loại",
              style: context.appTextTheme.titleLarge,
            ),
            Gaps.hGap8,
            SizedBox(
              height: 250,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: book.recommended!
                      .map((e) => Container(
                            height: 200,
                            width: 110,
                            padding: const EdgeInsets.only(right: 8),
                            child: ItemBook(
                              book: e,
                              layout: BookLayoutType.column,
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.detail,
                                    arguments: e.bookUrl);
                              },
                              onLongTap: () {},
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _genreBook(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thể loại"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: book.genres
                .map((e) => GenreCard(
                    genre: e,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.genreBook,
                          arguments:
                              GenreBookArg(genre: e, extension: extension));
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text("Giới thiệu"), Text(book.description)],
    );
  }
}
