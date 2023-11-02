async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);
  var detailEl = await Extension.querySelector(res, "div.detail_story");

  var name = await Extension.querySelector(
    detailEl.content,
    "div.profile-manga div div.post-title h1"
  ).text;

  if (name) {
    name = name.replace(/\n/g, "");
  }

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.summary_image a img",
    "src"
  );

  const lstElm = await Extension.querySelectorAll(
    detailEl.content,
    "div.detail_listInfo div.item"
  );
  let genres = [];
  var author = "";
  var statusBook = "";
  if (lstElm.length == 6) {
    author = await Extension.querySelector(
      lstElm[1].content,
      "div.info_value a"
    ).text;
    statusBook = await Extension.querySelector(
      lstElm[3].content,
      "div.info_value span"
    ).text;

    const genreEls = await Extension.querySelectorAll(
      lstElm[4].content,
      "div.info_value a"
    );

    for (var el of genreEls) {
      genres.push({
        url: await Extension.getAttributeText(el.content, "a", "href"),
        title: await Extension.querySelector(el.content, "a").text,
      });
    }
  }

  const description = await Extension.querySelector(
    res,
    "div.detail_reviewContent"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "#chapterlist ul li a")
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
