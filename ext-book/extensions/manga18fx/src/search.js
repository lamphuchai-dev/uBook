async function search(url, kw, page) {
  const res = await Extension.request(url, {
    queryParameters: { q: kw, page: page },
  });
  const lstEl = await Extension.querySelectorAll(res, "div.page-item");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "src");
    var bookUrl = await Extension.getAttributeText(
      html,
      "div.bsx-item div.bigor-manga  h3  a",
      "href"
    );
    var description = await await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga div.list-chapter div"
    ).text;

    var name = await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga h3 a"
    ).text;
    result.push({
      name: name.trim(),
      bookUrl: "https://manga18fx.com" + bookUrl,
      description: description.trim(),
      cover,
    });
  }
  return result;
}

runFn(() => search("https://manga18fx.com", "raw", 0));
