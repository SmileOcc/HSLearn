import { AddressInfo } from "./HSAddressModel"

export enum AddressItemType {
  FIRST_NAME,
  LAST_NAME,
  PHONE,
  STREET,
  STREET_DETAIL,
  DEFAULT,
  AREA,
  PROVINCE

}

@ObservedV2
export class AddressDetailGroupItem {
  childs: AddressDetailItemModel[] = []
  groupId: string = ""
  constructor(groupId: string, childs: AddressDetailItemModel[]) {
    this.groupId = groupId
    this.childs = childs
  }
}

@ObservedV2
export class AddressDetailItemModel {
  cid: string
  type: AddressItemType
  title: string = ""
  placeholder: string = ""
  tips: string = ""
  error?: string = ""
  isDefault?: boolean = false
  isMust?: boolean = false
  addressInfo?: AddressInfo
  onClick?:()=>void

  constructor(cid:string, title: string, type: AddressItemType) {
    this.cid = cid
    this.title = title
    this.type = type
  }
}