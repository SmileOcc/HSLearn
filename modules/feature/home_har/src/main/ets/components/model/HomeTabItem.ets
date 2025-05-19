/**
 * 首页tabBar信息
 */
export class HomeTabModel {
  // tabId用户切换tabContent
  id: number = 0;
  // tab类别
  navData: string | undefined = undefined;

  constructor(id: number, navData: string) {
    this.navData = navData;
    this.id = id;
  }
}