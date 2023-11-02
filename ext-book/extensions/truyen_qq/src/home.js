async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url.replace(".html", `/trang-${page}.html`);
  }


  const res = await Extension.request(url);
  const lstEl = await Extension.querySelectorAll(res, "ul.list_grid.grid li");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");
    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    result.push({
      name: await Extension.querySelector(html, "div.book_info a").text,
      bookUrl: await Extension.getAttributeText(
        html,
        "div.book_info a",
        "href"
      ),
      description: await await Extension.getAttributeText(
        html,
        "div.last_chapter a",
        "title"
      ),
      cover,
    });
  }
  return result;
}
