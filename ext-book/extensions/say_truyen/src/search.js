async function search(url, kw, page) {
  const res = await Extension.request(url + "/search", {
    queryParameters: {
      page: page,
      s: kw,
    },
  });
  const list = await Extension.querySelectorAll(res, "div.page-item-detail");
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");

    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    result.push({
      name: await Extension.querySelector(html, "div.post-title a").text,
      bookUrl: await Extension.getAttributeText(
        html,
        "div.post-title a",
        "href"
      ),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
  }
  return result;
}
