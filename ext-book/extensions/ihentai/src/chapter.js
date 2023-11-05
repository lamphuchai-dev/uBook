async function chapter(url) {
  const res = await Extension.request(url);
  const el = await Extension.getAttributeText(
    res,
    'div[class="tw-col-span-3 lg:tw-col-span-2"] iframe',
    "src"
  );
  return [
    {
      url: el,
      type: "iframe",
    },
  ];
}
