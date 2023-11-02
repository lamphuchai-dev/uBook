async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url + `/${page}`;
  }
  const res = await Extension.request(url);
  const lstEl = await Extension.querySelectorAll(
    res,
    "div.recoment_box div.story_item"
  );
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "src");
    var bookUrl = await Extension.getAttributeText(
      html,
      "div.mg_name a",
      "href"
    );
    var description = await await Extension.querySelector(
      html,
      "div.mg_chapter div.chapter_count a"
    ).text;
    description = description.replace(/\n/g, "");
    result.push({
      name: await Extension.querySelector(html, "div.mg_name a").text,
      bookUrl: "https://manga18.club" + bookUrl,
      description: description,
      cover,
    });
  }
  return result;
}
