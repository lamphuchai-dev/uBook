async function detail(bookUrl) {
  const res = await Extension.request(bookUrl, {
    headers: {
      "user-agent":
        "Mozilla/5.0 (Linux; Android 13; Pixel 7 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36",
    },
  });
  var data = await Extension.querySelector(
    res,
    'script[type="application/ld+json"]'
  ).text;

  const json = JSON.parse(data);
  const genresEl = await Extension.querySelectorAll(
    res,
    '.nh-section ul[class="list-unstyled"] li a'
  );

  let genres = [];

  for (var el of genresEl) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }
  const bookStatus = await Extension.querySelector(
    res,
    '.nh-section ul[class="list-unstyled"] li'
  ).text;
  const totalChapters = await Extension.querySelector(
    res,
    ".nh-section ul.list-unstyled li div.font-weight-semibold"
  ).text;

  // name: await Extension.querySelector(res, ".nh-section h1").text,
  // cover: await Extension.getAttributeText(res, ".nh-thumb.nh-thumb--150 img", "src"),
  return {
    name: json.name,
    cover: json.image,
    bookStatus: bookStatus ? bookStatus.trim() : "Đang cập nhật",
    bookUrl,
    author: json.author.name,
    description: await Extension.querySelector(
      res,
      ".tab-content .nh-section .content p"
    ).text,
    genres,
    totalChapters: totalChapters != "" && totalChapters ? +totalChapters : "",
  };
}
