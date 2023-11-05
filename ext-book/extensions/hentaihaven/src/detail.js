async function detail(bookUrl) {
  const host = "https://anime47.com";
  const res = await Extension.request(bookUrl);

  const name = await Extension.querySelector(res, "div.post-title h1").text;
  const authorRow = await Extension.querySelectorAll(
    res,
    "div.author-content a"
  );

  let genres = [];

  const description = await Extension.querySelector(
    res,
    "div.summary__content.show-more p"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "ul.main.version-chap li")
  ).length;

  const genreEls = await Extension.querySelectorAll(
    res,
    "div.genres-content a"
  );

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;
    genres.push({
      url: host + (await Extension.getAttributeText(el.content, "a", "href")),
      title: title.trim(),
    });
  }

  return {
    name: name.trim(),
    cover: await Extension.getAttributeText(
      res,
      "div.summary_image img",
      "src"
    ),
    bookUrl,
    statusBook: "",
    author: await Extension.querySelector(res, "div.author-content a").text,
    description: description ? description.trim() : "",
    genres,
    totalChapters,
  };
}

// runFn(() =>
//   detail("https://hentaihaven.xxx/watch/ikumonogakari-the-animation/")
// );
