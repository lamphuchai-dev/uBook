async function home(url, page) {
  if (!page) page = 1;
  const host = "https://ihentai.de";
  const res = await Extension.request(url, { page: page ?? 1 });

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
