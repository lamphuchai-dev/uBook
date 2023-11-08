async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);

  const detailEl = await Extension.querySelector(res, "article.item-detail");
  const name = await Extension.querySelector(
    detailEl.content,
    "h1.title-detail"
  ).text;
  var cover = await Extension.getAttributeText(
    res,
    "div.detail-info img",
    "data-original"
  );
  if (cover == null) {
    cover = await Extension.getAttributeText(res, "div.detail-info img", "src");
  }
  if (cover && cover.startsWith("//")) {
    cover = "https:" + cover;
  }

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

  var bookStatus = "";
  if (statusRow.length == 2) {
    bookStatus = await Extension.querySelector(statusRow[1].content, "p").text;
  }

  const description = await Extension.querySelector(
    detailEl.content,
    "div.detail-content p"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "div.list-chapter ul a")
  ).length;

  let genres = [];
  const genresEl = await Extension.querySelectorAll(
    detailEl.content,
    "li.kind.row p"
  );

  if (genresEl.length == 2) {
    const lstElm = await Extension.querySelectorAll(genresEl[1].content, "a");
    for (var el of lstElm) {
      genres.push({
        url: await Extension.getAttributeText(el.content, "a", "href"),
        title: await Extension.querySelector(el.content, "a").text,
      });
    }
  }

  return {
    name,
    cover,
    bookStatus,
    bookUrl,
    author,
    description,
    totalChapters,
    genres,
  };
}
