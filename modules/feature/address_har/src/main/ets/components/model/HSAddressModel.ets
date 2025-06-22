
@ObservedV2
export class HSAddressModel {
  addressId?: string
  province?: string
  provinceID?: string
  city?: string
  cityID?: string
  region?: string
  regionID?: string
  country?: string
  countryID?: string
  email?: string
  firstName?: string
  lastName?: string
  phone?: string
  phoneHead?: string
  phoneHeads?: string[]
  state?: string
  street?: string
  streetMore?: string
  zipPost?: string
  countryCode?: string
  isDefault: boolean = false
  latitude?: number
  longitude?: number

  user_id?: string
  area?: string
  areaId?: string
}

/**
 * 省、市、区共用的地址列表类
 */
export class CommonAddressList {
  code: string; // 存放省、市、区id
  name: string; // 存放省、市、区名

  constructor(code: string = '', name: string = '') {
    this.code = code;
    this.name = name;
  }
}

/**
 * 省信息类
 */
export class Province {
  code: string; // 省id
  name: string; // 省名
  children: City[]; // 存放市、区信息

  constructor(code: string = '', name: string = '', children: City[]) {
    this.code = code;
    this.name = name;
    this.children = children;
  }
}

/**
 * 市信息类
 */
class City {
  code: string = ''; // 市id
  name: string = ''; // 市名
  children: Region[]; // 存放区信息

  constructor(code: string = '', name: string = '', children: Region[]) {
    this.code = code;
    this.name = name;
    this.children = children;
  }
}

/**
 * 区信息类
 */
class Region {
  code: string = ''; // 区id
  name: string = ''; // 区名

  constructor(code: string = '', name: string = '') {
    this.code = code;
    this.name = name;
  }
}

/**
 * 省市区类型枚举
 */
export enum AddressType {
  Province = 0,
  City = 1,
  Region = 2
}

/**
 * 地点类
 */
export class Location {
  index: number = 0; // 省、市、区index。0表示省，1表示市，2表示区
  name: string = ''; // 用于显示省、市、区名
}

/**
 * 地址信息类
 */
@ObservedV2
export class AddressInfo {
  // 省id。对应address.json中第一级的code
  provinceId: string;
  // 市id。对应address.json中第二级的code
  cityId: string;
  // 区id。对应address.json中第三级的code
  regionId: string;
  // 省名。对应address.json中第一级的name
  @Trace
  province: string;
  // 市名。对应address.json中第二级的name
  @Trace
  city: string;
  // 区名。对应address.json中第三级的name
  @Trace
  region: string;

  constructor(province: string = '', city: string = '', region: string = '', provinceId: string = '',
    cityId: string = '', regionId: string = '') {
    this.province = province;
    this.city = city;
    this.region = region;
    this.provinceId = provinceId;
    this.cityId = cityId;
    this.regionId = regionId;
  }
}