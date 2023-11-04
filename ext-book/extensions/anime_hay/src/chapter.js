async function chapter(url) {
  var res = await Extension.request(url);

  // var data = res.match(/https:\/\/suckplayer\.xyz\/video\/[a-zA-Z0-9_-]+/g);

  var result = [];
  var link1 = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);
  if (link1) {
    result.push({
      url: link1[0],
      type: "iframe",
      regex: "playhydrax|player",
    });
  }

  var link2 = res.match(/\"https:\/\/scontent\.cdninstagram\.com\/[^\s]+\"/g);

  if (link2) {
    result.push({
      url: link2[0],
      type: "video",
    });
  }
  return result;
}

runFn(() =>
  chapter(
    "https://animehay.city/xem-phim/tran-hon-nhai-phan-3-tap-9-58893.html"
  )
);
