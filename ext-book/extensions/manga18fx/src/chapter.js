async function chapter(url) {
  const res = await Extension.request(url);
  const listEl = await Extension.querySelectorAll(res, "div.read-content img");
  let result = [];
  for (const element of listEl) {
    var image = await Extension.getAttributeText(element.content, "img", "src");
    result.push(image);
  }
  return result;
}
