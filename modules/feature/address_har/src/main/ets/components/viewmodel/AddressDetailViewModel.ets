import { IUState, YWBaseModel } from "@learn/common_har";
import { AddressDetailGroupItem, AddressDetailItemModel, AddressItemType } from "../model/AddressDetailItemModel";
import { AddressInfo, HSAddressModel } from "../model/HSAddressModel";

export class AddressDetailViewModel extends YWBaseModel<AddressUIState> {
  iuState: AddressUIState
  componentId: number
  constructor(componentId: number, iuState: AddressUIState) {
    super();
    this.componentId = componentId
    this.iuState = iuState
  }

  handleAddress(item:HSAddressModel) {
    item.province = item.state
    this.iuState.addressInfo = item
    const firstNameItem: AddressDetailItemModel = new AddressDetailItemModel("cid_0",item.firstName ?? "",AddressItemType.FIRST_NAME)
    firstNameItem.placeholder = "姓"
    firstNameItem.isMust = true
    const lastNameItem: AddressDetailItemModel = new AddressDetailItemModel("cid_1",item.lastName ?? "",AddressItemType.LAST_NAME)
    lastNameItem.placeholder = "名"
    lastNameItem.isMust = true
    const phoneItem: AddressDetailItemModel = new AddressDetailItemModel("cid_2",item.phone ?? "",AddressItemType.PHONE)
    phoneItem.placeholder = "请输入手机号"
    phoneItem.isMust = true
    const firstList: AddressDetailItemModel[] = [firstNameItem,lastNameItem,phoneItem]
    const firstGroup: AddressDetailGroupItem = new AddressDetailGroupItem("groupId_0",firstList)

    const streetItem: AddressDetailItemModel = new AddressDetailItemModel("cid_3",item.street ?? "",AddressItemType.STREET)
    streetItem.placeholder = "请输入地址"
    streetItem.isMust = true
    const streetDetailItem: AddressDetailItemModel = new AddressDetailItemModel("cid_4",item.streetMore ?? "",AddressItemType.STREET_DETAIL)
    streetDetailItem.placeholder = "请输入详细地址（可选）"
    const areaItem: AddressDetailItemModel = new AddressDetailItemModel("cid_5",item.area ?? "",AddressItemType.AREA)
    areaItem.placeholder = "请选择地区"
    areaItem.isMust = true

    const cityRegion = item.province + " " + item.city
    const cityItem: AddressDetailItemModel = new AddressDetailItemModel("cid_51",cityRegion,AddressItemType.PROVINCE)
    cityItem.placeholder = "省市区"
    cityItem.addressInfo = new AddressInfo();
    const secondList: AddressDetailItemModel[] = [streetItem,streetDetailItem,areaItem,cityItem]
    const secondGroup: AddressDetailGroupItem = new AddressDetailGroupItem("groupId_1",secondList)

    const defaultItem: AddressDetailItemModel = new AddressDetailItemModel("cie_6","默认地址",AddressItemType.DEFAULT)
    defaultItem.isDefault = item.isDefault
    const thirdGroup: AddressDetailGroupItem = new AddressDetailGroupItem("groupId_2",[defaultItem])

    this.iuState.groupList = [firstGroup, secondGroup, thirdGroup]
  }

  onClickItem(item:AddressDetailItemModel) {

  }
}

@ObservedV2
export class AddressUIState implements IUState {
  @Trace
  isLoading:boolean = true
  @Trace
  addressInfo?: HSAddressModel
  @Trace
  groupList?: AddressDetailGroupItem[]
  @Trace
  addressList?: AddressDetailItemModel[]

}