async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url + `/page/${page}`;
  }
  const res = await Extension.request(url);
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
