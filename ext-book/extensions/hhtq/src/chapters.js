async function chapters(bookUrl) {
  const host = "https://hhhtq.net";
  const res = await Extension.request(bookUrl);
  const listEl = await Extension.querySelectorAll(res, "#playlist1 li");
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const title = await Extension.querySelector(el, "a").text;
    chapters.push({
      title: title.trim(),
      url: host + url,
      bookUrl,
      index: index,
    });
  }
  return chapters;
}
