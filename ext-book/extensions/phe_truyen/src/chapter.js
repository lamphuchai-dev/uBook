async function chapter(url) {
  const res = await Extension.request(url);
  const listEl = await Extension.getElementsByClassName(res, "page-break");

  let result = [];
  for (const element of listEl) {
    var image = await Extension.getAttributeText(element.content, "img", "src");
    if (image != null) {
      image = image.replace(/\n/g, "");
    }
    result.push(image);
  }
  return result;
}
