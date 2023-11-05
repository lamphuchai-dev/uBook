async function genre(url) {
  const host = "https://ihentai.de";
  const res = await Extension.request(url + "/explore");

  const lstEl = await Extension.querySelectorAll(
    res,
    "div.v-card--density-default"
  );
  const result = [];

  for (const item of lstEl) {
    const html = item.content;
    result.push({
      url: host + (await Extension.getAttributeText(html, "a", "href")),
      title: await Extension.querySelector(html, "h3").text,
    });
  }
  return result;
}
