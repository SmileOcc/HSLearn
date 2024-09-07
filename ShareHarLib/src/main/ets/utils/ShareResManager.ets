
export class ShareResManager{
  static getPic(): Resource{
    return $r('app.media.app_icon');
  }
  static getDesc(): Resource{
    return $r('app.string.shared_desc');
  }
}