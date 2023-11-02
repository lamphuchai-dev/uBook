async function detail(bookUrl) {
  const host = "https://animehay.city";
  const res = await Extension.request(bookUrl);
  const detailEl = await Extension.querySelector(res, "div.book_detail");
  const name = await Extension.querySelector(
    detailEl.content,
    "h1.heading_movie"
  ).text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.info-movie img",
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
      'div[class ="list-item-episode scroll-bar"] a'
    )
  ).length;

  const genreEls = await Extension.querySelectorAll(
    detailEl.content,
    "div.list_cate a"
  );

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;
    genres.push({
      url: host + (await Extension.getAttributeText(el.content, "a", "href")),
      title: title.trim(),
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
