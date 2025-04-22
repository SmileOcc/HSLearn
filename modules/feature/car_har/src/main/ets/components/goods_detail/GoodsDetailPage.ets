import { YWRouterNavParams } from "@learn/nav_router_har"


@Builder
export function goodsDetailBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    GoodsDetailPage()
  }
}

@Entry
struct GoodsDetailPage {
  @State title: string = "detail"
  build() {
    Column(){
      Text(this.title)
    }
  }
}