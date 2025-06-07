export class ImageEditParam {

  //照片uri
  uri: string;

  //底部安全区高度
  bottomHeight: number;

  constructor(uri: string, bottomHeight: number) {
    this.uri = uri;
    this.bottomHeight = bottomHeight;
  }

}