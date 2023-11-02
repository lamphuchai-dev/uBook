// await Extension.querySelectorAll(html, "query")
// await Extension.querySelector(html, "query")
// await Extension.getAttributeText(html, "query","Attribute[src..]")
// await Extension.getElementById(html,"id","fun [text,outerHTML,innerHTML]")
// await Extension. getElementsByClassName(html,"className","fun")

async function execute(url, page) {
  var res = await Extension.request(url);
  var tmp = res.match(/source_fbo: \[(.*?)\]/);

  //   var textMatch = "var $info_play_video = ";
  //   var index = res.indexOf(textMatch);
  //   res = res.substring(index + textMatch.length, res.length);

  //   var textMatch = "var $list";
  //   var index = res.indexOf(textMatch);

  //   return JSON.stringify(res.substring(0, index));
  return extractAllText(tmp[1][1]);
}

runFn(() =>
  execute(
    "https://animehay.city/xem-phim/kage-no-jitsuryokusha-ni-naritakute-2nd-season-tap-5-59736.html"
  )
);

function extractAllText(str) {
  var re = /"(.*?)"/g;
  var result = [];
  var current;
  while ((current = re.exec(str))) {
    result.push(current.pop());
  }
  return result;
}
