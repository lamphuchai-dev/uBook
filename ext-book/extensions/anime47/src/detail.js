async function detail(bookUrl) {
  const host = "https://anime47.com";
  const res = await Extension.request(bookUrl);
  const detailEl = await Extension.querySelector(res, "div.movie-info");
  const name = await Extension.querySelector(detailEl.content, "span.title-1")
    .text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.movie-l-img img",
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

  var statusBook = await Extension.querySelector(
    detailEl.content,
    'dd[class="movie-dd imdb"]'
  ).text;

  let genres = [];

  const description = await Extension.querySelector(
    detailEl.content,
    "div.news-article"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "div.episodes ul li")
  ).length;

  const genreEls = await Extension.querySelectorAll(
    detailEl.content,
    'dd[class="movie-dd dd-cat"] a'
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
    description: description ? description.trim() : "",
    genres,
    totalChapters,
  };
}
