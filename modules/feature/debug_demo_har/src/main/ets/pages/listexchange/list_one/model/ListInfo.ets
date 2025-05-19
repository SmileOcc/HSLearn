/**
 * 列表信息，包括图标、名字、是否可见
 * icon: 列表项图标
 * name: 列表项名称
 */
@Observed
export class ListInfo {
  icon: ResourceStr = '';
  name: ResourceStr = '';

  constructor(icon: ResourceStr = '', name: ResourceStr = '') {
    this.icon = icon;
    this.name = name;
  }
}