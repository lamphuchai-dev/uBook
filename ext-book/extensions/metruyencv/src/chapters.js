async function chapters(bookUrl) {
  const htmlPage = await Browser.launch(bookUrl, 10000);
  if (htmlPage == null) return null;

  Browser.callJs(
    "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",
    1000
  );

  const data = await Browser.waitUrlAjaxResponse(
    ".*?api.truyen.onl/v2/chapters*?",
    10000
  );
  Browser.close();
  const chapters = [];
  data.response._data.chapters.forEach((chapter) => {
    chapters.push({
      title: chapter.name,
      url: "/chuong-" + chapter.index,
      host: bookUrl,
    });
  });
  return chapters;
}

runFn(() =>
  chapters(
    "https://metruyencv.com/truyen/dau-la-phan-phai-may-mo-phong-bat-dau-ham-hai-thien-nhan-tuyet"
  )
);
