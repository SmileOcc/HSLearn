
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
  itemClick?:()=>void
}
