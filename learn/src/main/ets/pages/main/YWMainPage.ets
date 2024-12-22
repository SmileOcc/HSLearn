import { YWAvoidAreas, getDefaultAvoidAreas, getAvoidPadding } from "@learn/common_har";
import { CategoryPage } from "../category/ctrl/CategoryPage";
import { HomePage } from "../home/ctrl/HomePage";
import MinePage from "../MinePage";
import { YWTabBar } from "./tab/YWTabBar";
import { YWTabItem } from "./tab/YWTabItem";
import { curves } from "@kit.ArkUI";
import { emitter } from "@kit.BasicServicesKit";
import { eventID } from "../../common/YWEventID";
import { API, NetMagicResp, netReq } from "@learn/request_har";
import { IAdvModel } from "../../data/IAdvModel";
import { YWAdvBanner } from "../home/view/YWAdvBanner";
import { YWConstants } from "@learn/constants_har";
import { hsLog } from "@learn/logger_har";

const TAG = 'YWMainPage'
// @Entry
@Component
export struct YWMainPage {
  @StorageProp(YWConstants.kStorageAreas) avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()
  @StorageProp('bottomHeight') bottomHeight: number = 0; //导航栏高度（单位：vp）
  @State selectIndex: number = 0
  @State tabItems: Array<YWTabItem> = [];

  async aboutToAppear(): Promise<void> {
    this.loadDefaultTabData();
    this.registerEvent();
    // dbUtils.initDB();
    this.loadServiceData();

    let ppadd = getAvoidPadding(this.avoidAreas)
  }

  build() {
    Stack() {
      YWTabBar({
        data: this.tabItems,
        selectIndex: this.selectIndex,
        page: this.buildCommonPage,
        onListener: (index) => {
          hsLog.i(TAG, 'click TabBar: ' + index);
        }
      })
        // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      //跳转到V1测试页面
      // HelperView()
    }
    .width('100%')
    .height('100%')
    // .padding(getAvoidPadding(this.avoidAreas))

    .backgroundColor($r('app.color.bg_base'))
    .alignContent(Alignment.Bottom)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

    //页面入场动画，从右到左TransitionEdge.END
    // .transition(TransitionEffect.SLIDE.combine(TransitionEffect.move(TransitionEdge.END)
    //   .animation({ curve: curves.springMotion() })))
  }

  /**
   * 普通版的页面
   */
  @Builder
  buildCommonPage(index: number): void {
    if (index == 0) {
      HomePage()
    } else if (index == 1) {
      CategoryPage()
    } else if (index == 2) {
      MinePage()
    }
  }

  /**
   * 加载底部Tab的数据
   */
  private loadDefaultTabData(): void {
    this.tabItems = [];
    this.tabItems.push(new YWTabItem($r('app.media.home_normal'), $r('app.media.tab_home_select'), '首页'),
      new YWTabItem($r('app.media.tab_new'), $r('app.media.tab_new_select'), '分类'),
      new YWTabItem($r('app.media.tab_me_normal'), $r('app.media.tab_me_select'), '我的'));
  }

  /**
   * 注册事件的监听器
   */
  private registerEvent(): void {
    //跳转到首页的那个页面
    emitter.on(eventID.GOTO_INDEX, (event: emitter.EventData) => {
      const index: number = event.data?.['index'];
      if (index === undefined || index >= this.tabItems.length) {
        return;
      }
      this.selectIndex = index;
    });
  }

  private loadServiceData() {
    netReq.postNotBody<IAdvModel>(API.bulletin, {
      onSuccess: (data: IAdvModel, magic?: NetMagicResp<IAdvModel>) => {
        hsLog.i(TAG, '数据回调：' + JSON.stringify(data));
        if (magic) {
          data.server_time = '' + magic.timestamp;
        }
        YWAdvBanner.show(data);
      }
    })
  }
}