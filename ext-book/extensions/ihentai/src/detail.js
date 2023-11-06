async function detail(bookUrl) {
  const host = "https://ihentai.de";
  const res = await Extension.request(bookUrl);

  const name = await Extension.querySelector(res, "div.tw-mb-3 h1").text;

  let genres = [];

  const description = await Extension.querySelector(
    res,
    'p[class ="tw-text-sm"]'
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "ul.main.version-chap li")
  ).length;

  const genreEls = await Extension.querySelectorAll(
    res,
    'div[class="v-chip-group v-chip-group--column v-theme--dark"] a'
  );

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "div.v-chip__content")
      .text;
    genres.push({
      url: host + (await Extension.getAttributeText(el.content, "a", "href")),
      title: title.trim(),
    });
  }

  var list = await Extension.querySelectorAll(
    res,
    'div[class ="tw-relative tw-grid tw-grid-cols-12 tw-gap-x-2"]'
  );
  const recommended = [];
  for (var item of list) {
    recommended.push({
      bookUrl:
        host + (await Extension.getAttributeText(item.content, "a", "href")),
      name: await Extension.querySelector(item.content, "a").text,
      cover: await Extension.getAttributeText(item.content, "img", "src"),
      description: await Extension.querySelector(
        item.content,
        'p[class ="text-medium-emphasis tw-text-sm tw-leading-tight"]'
      ).text,
    });
  }

  return {
    name: name.trim(),
    cover: await Extension.getAttributeText(res, "div.tw-relative img", "src"),
    bookUrl,
    statusBook: "",
    author: await Extension.querySelector(res, "div.author-content a").text,
    description: description ? description.trim() : "",
    genres,
    totalChapters,
    recommended,
  };
}
