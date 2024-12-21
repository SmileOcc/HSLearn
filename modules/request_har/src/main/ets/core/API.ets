import { HttpConstants } from "../requestConfig/HttpConstants";

/*
 * @Desc: 本来只是方便管理。服务接口api路径的配置，不同环境可以定义在rawfile进行区分加载
 */
export class API {
  static readonly local: string = HttpConstants.baseUrl;// TODO magic-api 项目的地址
  static readonly server: string = 'https://你的生产域名.com/';
  static readonly base_url: string = API.local;
  //第一版接口
  static readonly v1: string = 'sw/';
  //为了后续方便切换
  static readonly sw: string = API.v1;
  //广告页
  static readonly advert: string = `${API.sw}common/advert.do`;
  //首页公告
  static readonly bulletin: string = `${API.sw}common/bulletin.do`;
  //版本更新检测
  static readonly update: string = `${API.sw}common/update.do`;
  //获取音乐列表
  static readonly music: string = `${API.sw}common/music.do`;
  //获取 banner 数据
  static readonly banner: string = `${API.sw}common/banner.do`;
  //登录
  static readonly login: string = `${API.sw}login/auth.do`;
  //登出
  static readonly logout: string = `${API.sw}user/logout.do`;
  //获取登录后用户数据
  static readonly userInfos: string = `${API.sw}user/infos.do`;
  //更新头像
  static readonly updateAvatar: string = `${API.sw}user/updateAvatar.do`;
  //更新昵称
  static readonly updateName: string = `${API.sw}user/updateName.do`;
  //前端页面地址
  static readonly h5_resource: string = `${API.base_url}h5/`;
  //用户协议
  static readonly agreement: string = `${API.h5_resource}agreement.html`;
  //隐私政策
  static readonly privacy: string = `${API.h5_resource}privacy.html`;

  /**
   * 获取资源的全路径
   * @param url
   * @returns
   */
  static getResourceUrl(url: string): string {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    if (url.startsWith('/')) {
      url = url.slice(1)
    }
    return `${API.base_url}${url}`;
  }
}
