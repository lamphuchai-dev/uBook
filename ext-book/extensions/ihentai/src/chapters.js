async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);

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

  return result;
}
