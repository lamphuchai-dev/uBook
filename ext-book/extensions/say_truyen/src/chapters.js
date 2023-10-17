async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  const listEl = await Extension.querySelectorAll(res, "div.list-chapter ul a");
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const title = await Extension.querySelector(el, "a").text;
    chapters.push({
      title,
      url,
      bookUrl,
      index: listEl.length - 1 - index,
    });
  }
  return chapters;
}
