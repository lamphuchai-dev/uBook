async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  const host = "https://ihentai.de";

  var result = [];

  result.push({
    title: await Extension.querySelector(
      res,
      'h1[class="tw-text-lg tw-leading-tight"]'
    ).text,
    url: bookUrl,
    bookUrl,
    index: 0,
  });

  const tmp = await Extension.querySelector(
    res,
    'div[class ="tw-col-span-3 lg:tw-col-span-1"] div.tw-mb-5'
  ).outerHTML;

  var el = await Extension.querySelector(
    tmp,
    'h2[class = "tw-mb-1 tw-font-medium"] span'
  ).text;
  if (el.trim() == "Phim gợi ý") {
    result.push({
      title: await Extension.querySelector(tmp, "h3 a").text,
      url: host + (await Extension.getAttributeText(tmp, "h3 a", "href").text),
      bookUrl,
      index: 1,
    });
  }

  // 
  return result;
}
