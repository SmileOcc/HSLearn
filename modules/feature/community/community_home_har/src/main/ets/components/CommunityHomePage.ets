// import { LitheRefresh, RefreshController } from "@abner/lithe_refresh_v2";
import { ListView, RefreshController, RefreshDataSource } from "@abner/refresh_v2";
import { YWBaseNavBar, YWNavBar } from "@learn/baseui_har";
import { YWConstants } from "@learn/constants_har";
import { YWLazy } from "@learn/global_service_har";
import { YWLocalNavType, YWNavPath, ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har";
import { CommunityArticleInfo } from "./model/CommunityModel";
import { ArticleListView, ItemView } from "./view/ArticleListView";
import { SwiperData, SwiperItemViewType } from "./view/SwiperView";
import { SwiperItemView, TopBannerView } from "./view/TopBannerView";
import { CommunityUIState, CommunityViewModel } from "./viewmodel/CommunityViewModel";


@ComponentV2
export struct CommunityHomePage {
  uiState: CommunityUIState = new CommunityUIState()
  scroller: Scroller = new Scroller()
  controller: RefreshController = new RefreshController()
  dataSource: RefreshDataSource = new RefreshDataSource() //数据懒加载操作对象，执行数据增删改查
  isLoading: boolean = false
  isMore: boolean = false
  testLoadCount: number = 0

  viewModel:YWLazy<CommunityViewModel> = new YWLazy(()=>{
    return new CommunityViewModel(this.getUniqueId(), this.uiState)
  })

  aboutToAppear(): void {
    this.uiState.scroller = this.scroller
    this.refreshCommunity()
  }

  refreshCommunity() {
    this.viewModel.value.getCommunityInfo()
      .then(value =>{
        this.uiState.communityModel = value
        this.uiState.articleDatas.pushDataArray(value.items)

        let swiperListView: SwiperItemViewType[] = []
        this.uiState.communityModel.banners.forEach((value)=>{
          let data = new SwiperData(value.imageUrl ?? "", value.desc ?? "",
            "")
          swiperListView.push(new SwiperItemViewType(data, wrapBuilder(SwiperItemView)))
        })
        this.uiState.swiperListView = swiperListView

      })
  }

  loadMoreList(isLoad: boolean) {
    console.log('=============== orderList')

    //测试数据
    if (this.isLoading == false) {
      this.testLoadCount = 0
    }
    this.viewModel.value.getMoreArticle(this.isMore)
      .then(value => {

        console.log('========== order return')
        // this.orderList = this.orderList.concat(value)
        //
        // value.flatMap((item) => {
        //   this.orderListDataSource.pushData(item)
        // })
        // this.isLoading = false
        // this.isMore = false
        // this.testLoadCount++
        // if (value && value.length >= YWConstants.kPageSize10) {
        //   this.isMore = true
        //   if (this.testLoadCount > 3) {
        //     this.isMore = false
        //   }
        // }
      })
  }

  build() {
    Stack({alignContent:Alignment.TopStart}){
      // YWBaseNavBar({title:"", isExpandSafeArea: true, navBarColor:`rgba(255,255,255,0.8)`, defaultGoBack:()=>{
      //   ywNavRouter.openRoute(this.getUniqueId()).back()
      // }})
      //   .zIndex(100)
      Column(){
        this.listView()
      }
      .width('100%')
      .height('100%')
      .backgroundColor(YWConstants.RandomColor())
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  itemLayout(item: CommunityArticleInfo,index:number) {
    // ArticleListView({ uiState: this.uiState })
    ListItem() {
      ItemView({ item: item, isSelected: this.uiState.selectedId === item.id });
    }
  }

  @Builder
  headerLayout() {
    Column(){
      TopBannerView({uiState: this.uiState})
    }
    .width('100%')
    .aspectRatio(1.3333)
  }

  @Builder
  listView() {
    Column(){
      ListView({
        lazyDataSource: this.uiState.articleDatas,
        controller: this.controller,
        itemLayout: (item, index) => {
          this.itemLayout(item as CommunityArticleInfo, index)
        },
        itemHeaderLayout:()=>{
          this.headerLayout()

        },
        onRefresh: () => {
          //下拉刷新
          setTimeout(() => {
            this.controller.finishRefresh()
          }, 2000)
        },
        onLoadMore: () => {
          //上拉加载
          setTimeout(() => {

            this.controller.finishLoadMore()
          }, 2000)
        },
        onContentScroller:(scroller)=>{

        }
      })

    }
    .width('100%')
    // .padding({top:'12vp'})
    .layoutWeight(1)
  }
}

@Builder
export function communityHomeBuilder(name?: string, params?:YWRouterNavParams) {
  NavDestination(){
    CommunityHomePage()
  }
  .hideTitleBar(true)

}

ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_TAB,[
  {name:YWNavPath.root_community_nav, builder: wrapBuilder(communityHomeBuilder)}
])

