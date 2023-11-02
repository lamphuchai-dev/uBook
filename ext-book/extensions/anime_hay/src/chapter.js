async function chapter(url, page) {
  var res = await Extension.request(url);
  var data = res.match(/source_fbo: \[(.*?)\]/);
  return [extractAllText(data[1])[1]];
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
