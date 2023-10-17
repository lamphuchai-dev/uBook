async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);

  const detailBook = await Extension.querySelector(res, "div.book_detail")
    .outerHTML;

  const name = await Extension.querySelector(detailBook, "h1").text;

  var cover = await Extension.getAttributeText(
    detailBook,
    "div.book_avatar img",
    "src"
  );

  const authorRow = await Extension.querySelectorAll(detailBook, "li.author p");
  var author = "";
  if (authorRow.length == 2) {
    author = await Extension.querySelector(authorRow[1].content, "p").text;
  }

  const statusRow = await Extension.querySelectorAll(detailBook, "li.status p");

  var bookStatus = "";
  if (statusRow.length == 2) {
    bookStatus = await Extension.querySelector(statusRow[1].content, "p").text;
  }

  const description = await Extension.querySelector(
    detailBook,
    "div.story-detail-info p"
  ).text;

  const totalChapters = (
    await Extension.getElementsByClassName(res, "works-chapter-item")
  ).length;

  const genresEl = await Extension.querySelectorAll(detailBook, "ul.list01 li");

  let genres = [];

  for (var el of genresEl) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  return {
    name,
    cover,
    bookUrl,
    bookStatus,
    author,
    description,
    totalChapters,
    genres,
  };
}
