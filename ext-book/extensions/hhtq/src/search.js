async function search(url, kw, page) {
  if (!page) page = 1;
  const res = await Extension.request(
    url + `/vod/search/page/${page}/wd/${kw}/`
  );
  const host = "https://hhhtq.net";

  const lstEl = await Extension.querySelectorAll(res, "#searchList li");
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
