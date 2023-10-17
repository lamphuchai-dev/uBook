const mainCode = '''
class Element {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector || "";
  }

  async querySelector(selector) {
    return new Element(await this.excute(), selector);
  }

  async excute(fun) {
    return await sendMessage(
      "querySelector",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  async removeSelector(selector) {
    this.content = await sendMessage(
      "removeSelector",
      JSON.stringify([await this.outerHTML, selector])
    );
    return this;
  }

  async getAttributeText(attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([await this.outerHTML, this.selector, attr])
    );
  }

  get text() {
    return this.excute("text");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }

  get innerHTML() {
    return this.excute("innerHTML");
  }
}
class XPathNode {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector;
  }

  async excute(fun) {
    return await sendMessage(
      "queryXPath",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  get attr() {
    return this.excute("attr");
  }

  get attrs() {
    return this.excute("attrs");
  }

  get text() {
    return this.excute("text");
  }

  get allHTML() {
    return this.excute("allHTML");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }
}

class Extension {
  settingKeys = [];
  constructor(host,extensionName) {
    this.hostExt = host;
    this.extensionName = extensionName;

  }
  async request(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.method = options.method || "get";
    const res = await sendMessage("request", JSON.stringify([url, options]));
    // console.log(res)
    try {
      return JSON.parse(res);
    } catch (e) {
      return res;
    }
  }
  querySelector(content, selector) {
    return new Element(content, selector);
  }
  queryXPath(content, selector) {
    return new XPathNode(content, selector);
  }
  async querySelectorAll(content, selector) {
    let elements = [];
    JSON.parse(
      await sendMessage("querySelectorAll", JSON.stringify([content, selector]))
    ).forEach((e) => {
      elements.push(new Element(e, selector));
    });
    return elements;
  }
  async getAttributeText(content, selector, attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([content, selector, attr])
    );
  }
  async home() {
    throw new Error("not implement home");
  }

  async itemHome() {
    throw new Error("not implement home");
  }

  search(kw, page, filter) {
    throw new Error("not implement search");
  }
  createFilter(filter) {
    throw new Error("not implement createFilter");
  }
  detail(url) {
    throw new Error("not implement detail");
  }
  chapters(url){
    throw new Error("not implement chapter");

  }
  chapter(url) {
    throw new Error("not implement chapter");
  }

  checkUpdate(url) {
    throw new Error("not implement checkUpdate");
  }
  async getSetting(key) {
    return sendMessage("getSetting", JSON.stringify([key]));
  }
  async registerSetting(settings) {
    console.log(JSON.stringify([settings]));
    this.settingKeys.push(settings.key);
    return sendMessage("registerSetting", JSON.stringify([settings]));
  }
  async load() {}


}

console.log = function (message) {
  if (typeof message === "object") {
    message = JSON.stringify(message);
  }
  sendMessage("log", JSON.stringify([message.toString()]));
};

async function stringify(callback) {
  const data = await callback();
  return typeof data === "object" ? JSON.stringify(data) : data;
}

''';

const netTruyen = '''
export default class extends Extension {

  async itemHome(url, page) {
    const res = await this.request( this.hostExt + url, { queryParameters: { page: page ?? 0 } });
    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];


    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-original");
      if(cover == null){
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }

      result.push({
        name: await this.querySelector(html, "h3 a").text,
        bookUrl: await this.getAttributeText(html, "h3 a", "href"),
        description : await this.querySelector(html, ".comic-item li a").text,
        host:this.hostExt,
        cover,
      });
    }
    return result;
  }

  async detail(url) {
    const res = await this.request(url);

    const detailEl = await this.querySelector(res, "article.item-detail");
    const name = await this.querySelector(detailEl.content, "h1.title-detail")
      .text;
    var cover =  await this.getAttributeText(res, "div.detail-info img","data-original");
    if(cover == null){
      cover = await this.getAttributeText(res, "div.detail-info img","src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    const authorRow = await this.querySelectorAll(
      detailEl.content,
      "li.author p"
    );
    const author = await this.querySelector(authorRow[1].content, "p").text;

    const description = await this.querySelector(
      detailEl.content,
      "div.detail-content p"
    ).text;

    const chapters =await this.chapters(url,res);
    return {
      name,
      cover,
      bookUrl:url, 
      author,
      description,
      host:this.hostExt,
      chapters,
      totalChapter:chapters.length
    };

  }

  async chapters(bookUrl,html) {
    if(html == null){
      html = await this.request(url);
    }
    
    const listEl = await this.querySelectorAll(html, "div.list-chapter ul a");
    const chapters = [];


    for(var index = 0;index < listEl.length; index ++){
      const el = listEl[index].content;
      const url = await this.getAttributeText(el, "a", "href");
      const title = await this.querySelector(el, "a").text;
      chapters.push({
        title,
        url,
        bookUrl,
        index:  listEl.length - index,
      });
    }
    return chapters;
  }



  async chapter(url) {
    const res = await this.request(url);
    const listEl = await this.querySelectorAll(res, "div.page-chapter img");
    let result = [];
    for (const element of listEl) {
      var image = await this.getAttributeText(element.content, "img", "src");
      var otherUrl = await this.getAttributeText(
        element.content,
        "img",
        "data-original"
      );
      if (image && image.startsWith("//")) {
        image = "https:" + image;
      }
      if (otherUrl && otherUrl.startsWith("//")) {
        otherUrl = "https:" + otherUrl;
      }
      result.push({ url:image, otherUrl });
    }
    return result;
  }

  async search(kw, page, filter) {
    const res = await this.request(this.hostExt + "/tim-truyen", {
      queryParameters: { page: page, keyword: kw },
    });

    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];
    for (const item of list) {
      var html = item.content;
      var cover =  await this.getAttributeText(html, "img", "src");
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "h3 a").text,
        bookUrl: await this.getAttributeText(html, "h3 a", "href"),
        description : await this.querySelector(html, ".comic-item li a").text,
        host:this.hostExt,
        cover,
      });
    }
    return result;
  }
}
''';

const sayTruyen = '''
export default class extends Extension {
  async itemHome(url, page) {

    const res = await this.request(this.hostExt + url, {
      queryParameters: {
        page: page ?? 0,
      },
    });
    return res;

    const list = await this.querySelectorAll(res, "div.page-item-detail");
    const result = [];
    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-src");

      if (cover == null) {
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "div.post-title a").text,
        bookUrl: await this.getAttributeText(html, "div.post-title a", "href"),
        description: await await this.querySelector(html, "div.chapter-item a")
          .text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }
  async detail(url) {
    const res = await this.request(url);

    const detailEl = await this.querySelector(res, "div.site-content");
    const name = await this.querySelector(detailEl.content, "div.post-title h1")
      .text;
    var cover = await this.getAttributeText(
      detailEl.content,
      "div.summary_image img",
      "src"
    );
    const authorRow = await this.querySelectorAll(
      detailEl.content,
      "div.post-content_item"
    );
    const author = await this.querySelector(
      authorRow[1].content,
      "div.summary-content"
    ).text;
    const description = await this.querySelector(
      detailEl.content,
      "div.description-summary p"
    ).text;
    return {
      name,
      cover,
      bookUrl: url,
      author,
      description,
      host: this.hostExt,
    };
  }
  async chapters(bookUrl, html) {
    if (html == null) {
      html = await this.request(bookUrl);
    }
    const listEl = await this.querySelectorAll(html, "div.list-chapter ul a");
    const chapters = [];
    for (var index = 0; index < listEl.length; index++) {
      const el = listEl[index].content;
      const url = await this.getAttributeText(el, "a", "href");
      const title = await this.querySelector(el, "a").text;
      chapters.push({
        title,
        url,
        bookUrl,
        index: listEl.length - index,
      });
    }
    return chapters;
  }
  async chapter(url) {
    const res = await this.request(url);
    const listEl = await this.querySelectorAll(
      res,
      "div.reading-content div.page-break"
    );
    let result = [];
    for (const element of listEl) {
      var image = await this.getAttributeText(element.content, "img", "src");
      
      result.push(image);
    }
    return result;
  }
  async search(kw, page, filter) {
    const res = await this.request(this.hostExt + "/search", {
      queryParameters: {
        page: page,
        s: kw,
      },
    });
    const list = await this.querySelectorAll(res, "div.page-item-detail");
    const result = [];
    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-src");
      if (cover == null) {
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "div.post-title a").text,
        bookUrl: await this.getAttributeText(html, "div.post-title a", "href"),
        description: await await this.querySelector(html, "div.chapter-item a")
          .text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }
}
''';
