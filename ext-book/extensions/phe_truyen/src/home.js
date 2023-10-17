async function home(url, page) {
  const res = await Extension.request(url, {
    queryParameters: {
      page: page ?? 1,
    },
  });
  const list = await Extension.querySelectorAll(res, "ul.list_grid li");
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");
    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    result.push({
      name: await Extension.querySelector(html, "h3 a").text,
      bookUrl: await Extension.getAttributeText(html, "h3 a", "href"),
      description: await await Extension.querySelector(
        html,
        "div.last_chapter a"
      ).text,
      cover,
    });
  }
  return result;
}
