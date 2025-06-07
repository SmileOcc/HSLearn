
export enum MineInfoType{
  unknow,
  head,
  nick,
  name,
  sex,
  phone,
  date,
}

@ObservedV2
export class MineInfoItemModel {
  infoType:MineInfoType = MineInfoType.unknow
  title:string|undefined
  desc:string|undefined
  avatar:string|undefined
  isArrow:boolean = false

}