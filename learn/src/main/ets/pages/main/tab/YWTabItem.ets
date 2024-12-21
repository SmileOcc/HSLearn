/**
 * 底部导航栏的数据类
 */
export class YWTabItem {
  protected _srcNormal: PixelMap | ResourceStr | DrawableDescriptor;

  public set srcNormal(value: PixelMap | ResourceStr | DrawableDescriptor) {
    this._srcNormal = value;
  }

  public get srcNormal(): PixelMap | ResourceStr | DrawableDescriptor {
    return this._srcNormal;
  }

  protected _srcSelect: PixelMap | ResourceStr | DrawableDescriptor;

  public set srcSelect(value: PixelMap | ResourceStr | DrawableDescriptor) {
    this._srcSelect = value;
  }

  public get srcSelect(): PixelMap | ResourceStr | DrawableDescriptor {
    return this._srcSelect;
  }

  protected _name: string | Resource;

  public set name(value: string | Resource) {
    this._name = value;
  }

  public get name(): string | Resource {
    return this._name;
  }

  constructor(srcNormal: PixelMap | ResourceStr | DrawableDescriptor, srcSelect: PixelMap | ResourceStr | DrawableDescriptor, name: string | Resource) {
    this._srcNormal = srcNormal;
    this._srcSelect = srcSelect;
    this._name = name;
  }
}