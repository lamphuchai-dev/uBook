async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);
  const detailEl = await Extension.querySelector(res, "div.book_detail");
  const name = await Extension.querySelector(
    detailEl.content,
    "div.book_other h1"
  ).text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.book_avatar img",
    "src"
  );

  const authorRow = await Extension.querySelectorAll(
    detailEl.content,
    "li.author p"
  );
  var author = "";
  if (authorRow.length == 2) {
    author = await Extension.querySelector(authorRow[1].content, "p").text;
  }

  const statusRow = await Extension.querySelectorAll(
    detailEl.content,
    "li.status p"
  );

  var statusBook = "";
  if (statusRow.length == 2) {
    statusBook = await Extension.querySelector(statusRow[1].content, "p").text;
  }

  let genres = [];

  const description = await Extension.querySelector(
    detailEl.content,
    "div.detail-content p"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(
      res,
      "div.works-chapter-list div.works-chapter-item"
    )
  ).length;

  const genreEls = await Extension.querySelectorAll(
    detailEl.content,
    "ul.list01 li"
  );

  for (var el of genreEls) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  return {
    name,
    cover,
    bookUrl,
    statusBook,
    author,
    description,
    genres,
    totalChapters,
  };
}
