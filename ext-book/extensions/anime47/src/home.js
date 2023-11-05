async function home(url, page) {
  const host = "https://anime47.com";
  if (!page) page = 1;
  if (url != host) {
    url = url + `/${page}.html`;
  }

  const res = await Extension.request(url);

  const lstEl = await Extension.querySelectorAll(res, "#movie-last-movie li");
  const result = [];

  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(
      html,
      "div.public-film-item-thumb",
      "style"
    );
    result.push({
      name: await Extension.getAttributeText(html, "a", "title"),
      bookUrl: host + (await Extension.getAttributeText(html, "a", "href")),
      description: await await Extension.querySelector(
        html,
        'span[class = "ribbon"]'
      ).text,
      cover: cover
        ? cover.replace("background-image:url('", "").replace("')", "")
        : null,
    });
  }
  return result;
}
