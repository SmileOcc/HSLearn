
export enum MineInfoType{
  unknow,
  head,
  nick,
  name,
  sex,
  phone,
  date,
}

@Observed
export class MineInfoItemModel {
  infoType:MineInfoType = MineInfoType.unknow
  title:string|undefined
  desc:string|undefined
  avatar:string|undefined
  isArrow:boolean = false

}