import { YWNavPath } from "@learn/nav_router_har"

@ObservedV2
export class MineServiceGroup {
  groupTitle?: string
  @Trace
  items?:MineServiceModel[]
  hasMore?: boolean
  moreClick?:()=>void
}

@ObservedV2
export class MineServiceModel {
  itemImage?: ResourceStr
  itemTitle?: ResourceStr
  @Trace
  badge?: number
  desc?: string
  @Trace
  tips?: string
  navPath?: YWNavPath
  itemClick?:(item:MineServiceModel)=>void
  borderRadius: number = 0 //1 上 2 下
}
