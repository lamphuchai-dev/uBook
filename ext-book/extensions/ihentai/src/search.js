async function search(url, kw, page) {
  const res = await Extension.request(url + "/search", {
    queryParameters: {
      page: page,
      s: kw,
    },
  });
  const host = "https://ihentai.de";
  const lstEl = await Extension.querySelectorAll(
    res,
    "div.v-card--density-default"
  );
  const result = [];

  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "src");
    result.push({
      name: await Extension.getAttributeText(html, "img", "title"),
      bookUrl: host + (await Extension.getAttributeText(html, "a", "href")),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
  }
  return result;
}
