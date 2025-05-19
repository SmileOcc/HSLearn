/**
 * App信息，包括图标、名字、是否可见
 */
@Observed
export class AppInfo {
  icon: ResourceStr = ''; // 应用图标
  name: ResourceStr = ''; // 应用名称
  visible: boolean = true; // 是否可见
  alp: number = 1
  showBorder: boolean = false
  cid: string

  constructor(cid: string, icon: ResourceStr = '', name: ResourceStr = '', visible: boolean = true) {
    this.cid = cid
    this.icon = icon;
    this.name = name;
    this.visible = visible;
  }
}