async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);
  const detailEl = await Extension.querySelector(res, "div.site-content");
  const name = await Extension.querySelector(
    detailEl.content,
    "div.post-title h1"
  ).text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.summary_image img",
    "src"
  );
  const lstElm = await Extension.querySelectorAll(
    detailEl.content,
    "div.post-content_item"
  );
  var author = "";
  var statusBook = "";

  let genres = [];

  const genreEls = await Extension.querySelectorAll(
    detailEl.content,
    "div.genres-content a"
  );

  for (var el of genreEls) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  if (lstElm.length == 6) {
    author = await Extension.querySelector(
      lstElm[1].content,
      "div.summary-content"
    ).text;
    statusBook = await Extension.querySelector(
      lstElm[4].content,
      "div.summary-content"
    ).text;
    statusBook = statusBook
      .replace("                        ", "")
      .replace("                    ", "")
      .replace(/\n/g, "");
  }

  const description = await Extension.querySelector(
    detailEl.content,
    "div.description-summary p"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "div.list-chapter ul a")
  ).length;

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
