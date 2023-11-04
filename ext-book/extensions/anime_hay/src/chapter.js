async function chapter(url, page) {
  var res = await Extension.request(url);
  var result = [];
  // var data = res.match(/https:\/\/suckplayer\.xyz\/video\/[a-zA-Z0-9_-]+/g);
  var link1 = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);
  if (link1) {
    result.push({
      url: link1[0],
      type: "iframe",
      regex: "playhydrax|player",
    });
  }
  var matchs = res.match(/source_fbo: \[(.*?)\]/);

  if (matchs) {
    var link2 = extractAllText(matchs[1])[1];
    if (link2) {
      result.push({
        url: link2,
        type: "video",
      });
    }
  }
  return result;
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
