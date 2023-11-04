async function chapter(url, page) {
  var res = await Extension.request(url);
  var result = [];
  // var data = res.match(/https:\/\/suckplayer\.xyz\/video\/[a-zA-Z0-9_-]+/g);
  var link1 = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);
  if (link1) {
    result.push({
      url: data[0],
      type: "iframe",
      regex: "playhydrax|player",
    });
  }
  var link2 = res.match(/source_fbo: \[(.*?)\]/);

  if (link2) {
    var urlVideo = extractAllText(data[1])[1];
    if (urlVideo) {
      result.push({
        url: urlVideo,
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
