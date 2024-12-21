import web_webview from '@ohos.web.webview'

/*
 * @Desc: 控制标题的样式和内容。
 */
export class CenterWebParm {
  url: string;
  attrModifier: AttributeModifier<WebAttribute>;
  controller: WebviewController;

  constructor(url: string, attrModifier: AttributeModifier<WebAttribute> = {},
    controller: WebviewController = new web_webview.WebviewController()) {
    this.url = url;
    this.attrModifier = attrModifier;
    this.controller = controller;
  }
}