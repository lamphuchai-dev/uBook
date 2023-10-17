async function genre(url) {
  const res = await Extension.request(url);
  const listEl = await Extension.querySelectorAll(
    res,
    "div.book_tags_content p"
  );

  let result = [];
  for (const element of listEl) {
    result.push({
      title: await Extension.querySelector(element.content, "a").text,
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return result;
}
