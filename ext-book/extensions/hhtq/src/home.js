async function home(url, page) {
  if (!page) page = 1;
  url = url.replace("page", page);
  const host = "https://hhhtq.net";
  const res = await Extension.request(url);

  const lstEl = await Extension.querySelectorAll(res, "div.myui-vodlist__box");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "a", "data-original");
    if (cover) {
      result.push({
        name: await Extension.getAttributeText(html, "a", "title"),
        bookUrl: host + (await Extension.getAttributeText(html, "a", "href")),
        description: await await Extension.querySelector(
          html,
          'span[class = "pic-tag pic-tag-top"] b'
        ).text,
        cover: cover,
      });
    }
  }
  return result;
}
