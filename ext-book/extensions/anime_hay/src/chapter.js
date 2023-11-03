async function chapter(url, page) {
  var res = await Extension.request(url);
  // var data = res.match(/https:\/\/suckplayer\.xyz\/video\/[a-zA-Z0-9_-]+/g);
  var data = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);

  if (!data) {
    var data = res.match(/source_fbo: \[(.*?)\]/);
    var urlVideo = extractAllText(data[1])[1];
    if (!urlVideo) return null;
    return [urlVideo];
  }
  return [data[0], "iframe"];
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
