import 'package:h_book/data/models/book.dart';
import 'package:h_book/data/models/chapter.dart';
import 'package:h_book/data/models/data_test.dart';

final masterTest = {
  "info": {
    "name": "Mê Truyện CV",
    "author": "hBook",
    "version": 1,
    "source": "https://metruyencv.com",
    "regexp":
        r'(www.)?(metruyenchu|mtccv|metruyencv).com/truyen/[a-zA-Z0-9-]+/?$',
    "description": "Đọc truyện trên trang Mê Truyện CV",
    "locale": "vi_VN",
  },
  "homeTabs": [
    {
      "title": "Mới cập nhật",
      "fetch": "headless",
      "replacePage": "index",
      "url":
          r'https://metruyencv.com/truyen/?sort_by=new_chap_at&status=-1&props=-1&limit=20&page=index',
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Chọn lọc",
      "fetch": "headless",
      "replacePage": "index",
      "url":
          "https://metruyencv.com/truyen?sort_by=new_chap_at&props=1&page=index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Thịnh hàng",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/thinh-hanh/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Đọc nhiều",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/doc-nhieu/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Tặng tưởng",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/tang-thuong/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Đề cử",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/de-cu/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Yêu thích",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/yeu-thich/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
    {
      "title": "Thảo luận",
      "fetch": "headless",
      "replacePage": "index",
      "url": "https://metruyencv.com/bang-xep-hang/tuan/thao-luan/index",
      "regexp": "api.truyen.onl/v2/books",
      "scripts": [
        {
          "script":
              '''function execute(dataString) {try {  var jsonData = JSON.parse(JSON.stringify(dataString));  var books = [];var nextPage = jsonData._extra._pagination._next;jsonData._data.forEach((book) => {  books.push({name: book.name,link: "/truyen/" + book.slug,author_name: book.author_name,description: book.synopsis,poster: book["poster"]["default"],host: "https://metruyencv.com",chapter_count:book.chapter_count  });});  return {"books":books,"nextPage":nextPage};} catch (error) {  return null;}}''',
          "injectionTime": "UserScript",
        }
      ]
    },
  ],
  "pages": [
    {
      "title": "detail",
      "fetch": "headless",
      "url":
          "https://metruyencv.com/truyen/tu-luyen-tu-thu-thap-nhan-vat-the-bat-dau",
      "regexp": "api.truyen.onl/v2/chapters",
      "scripts": [
        {
          "script":
              "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",
          "injectionTime": "StopLoadPage",
        }
      ]
    },
    {
      "title": "chapters",
      "fetch": "headless",
      "url": "https://metruyencv.com/truyen/",
      "regexp": "api.truyen.onl/v2/chapters",
      "scripts": [
        {
          "script":
              "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click() }} return true",
          "injectionTime": "StopLoadPage",
        },
        {
          "script": '''function execute(dataString) {
  try {
    var jsonData = JSON.parse(JSON.stringify(dataString));
    var chapters = [];
    jsonData._data.chapters.forEach((chapter) => {
      chapters.push({
        name: chapter.name,
        slug: "/truyen/" + chapter.slug,
        index: chapter.index,
        published_at: chapter.synopsis,
      });
    });
    return chapters;
  } catch (error) {
    return null;
  }
}

''',
          "injectionTime": "UserScript",
        }
      ]
    },
  ]
};

final book = Book(
    name: "Cẩu Tại Yêu Võ Loạn Thế Tu Tiên",
    link: "https://metruyencv.com/truyen/cau-tai-yeu-vo-loan-the-tu-tien",
    authorName: "Văn Sao Công",
    description:
        "Phương Tịch xuyên rồi, mà lại là nhị xuyên!\nTại tu tiên giới ta khúm núm, tại dị thế giới ta trọng quyền xuất kích!\nKhông nghĩ tới trăm ngàn năm về sau, tại tu tiên giới cũng thành đại lão!",
    poster:
        "https://static.cdnno.com/poster/cau-tai-yeu-vo-loan-the-tu-tien/300.jpg?1675827437",
    host: "metruyencv",
    chapterCount: 20,
    readChapterIndex: 0,
    chapters: [
      Chapter(
          id: "1",
          bookId: "12",
          name: "Gia hỏa này là tới thật sự?",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 1,
          publishedAt: DateTime.now().toIso8601String(),
          content: stringDataLong),
      Chapter(
          id: "2",
          bookId: "12",
          name: "Sở Quang cùng kẹo que",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 2,
          publishedAt: DateTime.now().toIso8601String(),
          content: test1),
      Chapter(
          id: "1",
          bookId: "12",
          name: "Chương 3",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 3,
          publishedAt: DateTime.now().toIso8601String(),
          content: test2),
      Chapter(
          id: "1",
          bookId: "12",
          name: "Chương 4",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 4,
          publishedAt: DateTime.now().toIso8601String(),
          content: test3),
      Chapter(
          id: "1e",
          bookId: "12fe",
          name: "Chương 5",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 5,
          publishedAt: DateTime.now().toIso8601String(),
          content: test4)
    ]);

final bookTest2 = Book(
    name: "Cẩu Tại Yêu Võ Loạn Thế Tu Tiên",
    link: "https://metruyencv.com/truyen/cau-tai-yeu-vo-loan-the-tu-tien",
    authorName: "Văn Sao Công",
    description:
        "Phương Tịch xuyên rồi, mà lại là nhị xuyên!\nTại tu tiên giới ta khúm núm, tại dị thế giới ta trọng quyền xuất kích!\nKhông nghĩ tới trăm ngàn năm về sau, tại tu tiên giới cũng thành đại lão!",
    poster:
        "https://static.cdnno.com/poster/cau-tai-yeu-vo-loan-the-tu-tien/300.jpg?1675827437",
    host: "metruyencv",
    chapterCount: 20,
    readChapterIndex: 0,
    chapters: [
      Chapter(
          id: "1",
          bookId: "12",
          name: "Chương 1",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 1,
          publishedAt: DateTime.now().toIso8601String(),
          content: ngan),
      Chapter(
          id: "2",
          bookId: "12",
          name: "Chương 2",
          slug: "cau-tai-yeu-vo-loan-the-tu-tien",
          index: 2,
          publishedAt: DateTime.now().toIso8601String(),
          content: ngan),
    ]);
