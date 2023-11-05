async function chapter(url) {
  const res = await Extension.request(url);
  const el = await Extension.getAttributeText(
    res,
    "div.player_logic_item iframe",
    "src"
  );
  return [
    {
      url: el,
      type: "iframe",
    },
  ];
}
