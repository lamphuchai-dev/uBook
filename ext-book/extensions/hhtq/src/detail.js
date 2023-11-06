async function detail(bookUrl) {
  const host = "https://hhhtq.net";
  const res = await Extension.request(bookUrl);
  const detailEl = await Extension.querySelector(res, "div.book_detail");
  const name = await Extension.querySelector(detailEl.content, "h1").text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.myui-content__thumb a img",
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
    "div.myui-panel_bd b"
  ).text;

  const totalChapters = (await Extension.querySelectorAll(res, "#playlist1 li"))
    .length;

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

  var listEl = await Extension.querySelectorAll(
    res,
    'ul[id="type"] div.myui-vodlist__box'
  );
  const recommended = [];
  for (var item of listEl) {
    var coverItem = await Extension.getAttributeText(
      item.content,
      "a.myui-vodlist__thumb",
      "style"
    );
    if (coverItem) {
      recommended.push({
        bookUrl:
          host +
          (await Extension.getAttributeText(
            item.content,
            "a.myui-vodlist__thumb",
            "href"
          )),
        name: await Extension.querySelector(
          item.content,
          'h4[class ="title text-overflow"] b'
        ).text,
        cover: coverItem.replace("background: url(", "").replace(");", ""),
        description: await Extension.querySelector(
          item.content,
          'p[class ="text-medium-emphasis tw-text-sm tw-leading-tight"]'
        ).text,
      });
    }
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
    recommended,
  };
}
