import { RefreshDataSource } from "@abner/refresh_v2";
import { HSDataSource, HSLazyBaseModel } from "@learn/base_model_har";
import { IUState, YWBaseModel } from "@learn/common_har"
import { hsMockManager } from "@learn/res_har";
import { CommunityArticleInfo, CommunityModel } from "../model/CommunityModel";
import { SwiperItemViewType } from "../view/SwiperView";

export class CommunityViewModel extends YWBaseModel<CommunityUIState> {
  iuState: CommunityUIState
  componentId: number
  constructor(componentId: number, iuState: CommunityUIState) {
    super();
    this.componentId = componentId
    this.iuState = iuState
  }

  getCommunityInfo():Promise<CommunityModel> {
    return new Promise((resolve,reject) => {
      let info = hsMockManager.reqCommunityHome() as CommunityModel
      resolve(info)
    })
  }

  getMoreArticle(isMore: boolean): Promise<CommunityArticleInfo[]> {
    return new Promise((resolve, reject) =>{
      let list = hsMockManager.reqCommunityArticleList() as CommunityArticleInfo[]
      resolve(list)
    })
  }
}

@ObservedV2
export class CommunityUIState implements IUState {
  @Trace
  isLoading:boolean = true
  @Trace
  communityModel?: CommunityModel
  @Trace
  // articleDatas: HSDataSource<CommunityArticleInfo> = new HSDataSource([])
  articleDatas: RefreshDataSource = new RefreshDataSource()

  scroller: Scroller = new Scroller()

  @Trace
  currentBannerIndex: number = 0

  @Trace
  selectedId: number = -1
  // 轮播模块列表
  @Trace
  swiperListView: SwiperItemViewType[] = [];
}