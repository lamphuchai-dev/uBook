async function chapter(url, page) {
  var res = await Extension.request(url);
  var data = res.match(/source_fbo: \[(.*?)\]/);
  var urlVideo = extractAllText(data[1])[1];
  if (!urlVideo) {
    data = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);
    if (!data) {
      return null;
    }
    return [data[0], "iframe"];
  }
  return [urlVideo];
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
