async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url.replace(".html", `/trang-${page}.html`);
  }

  const res = await Extension.request(url);
  const lstEl = await Extension.querySelectorAll(res, "div.movie-item");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;

    result.push({
      name: await Extension.getAttributeText(html, "a", "title"),
      bookUrl: await Extension.getAttributeText(html, "a", "href"),
      description: await await Extension.querySelector(
        html,
        "div.episode-latest span"
      ).text,
      cover: await Extension.getAttributeText(html, "img", "src"),
    });
  }
  return result;
}
