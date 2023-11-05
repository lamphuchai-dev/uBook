async function chapter(url) {
  var res = await Extension.request(url);
  // load sv fetch moi html theo linh
  var slides_p_path = res.match(/var player_aaaa=\{(.*?)\}/);
  if (extractAllText(slides_p_path[1]).length > 12) {
    const content = extractAllText(slides_p_path[1])[12];

    return [
      {
        url: content,
        type: "iframe",
        regex: "",
      },
    ];
  }

  return [];
}

function extractAllText(str) {
  var re = /"(.*?)"/g;
  var result = [];
  var current;
  while ((current = re.exec(str))) {
    result.push(current.pop());
  }
  return result;
}
