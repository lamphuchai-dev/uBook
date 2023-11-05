async function home(url, page) {
  if (!page) page = 1;
  url = url + `/page/${page}/`;
  const res = await Extension.request(url);

  const lstEl = await Extension.querySelectorAll(
    res,
    "div.page-item-detail.video"
  );
  const result = [];

  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "src");
    result.push({
      name: await Extension.getAttributeText(html, "a", "title"),
      bookUrl: await Extension.getAttributeText(html, "a", "href"),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
  }
  return result;
}

//runFn(() => home("https://hentaihaven.xxx/release/2023/", 2));
