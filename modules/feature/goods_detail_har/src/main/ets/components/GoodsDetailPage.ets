import { HSDataSource, HSLazyDataSource } from "@learn/base_model_har";
import { YWLocalNavType, YWNavPath, ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har";
import { GoodsItemModel } from "./model/GoodsItemModel";
import { common } from "@kit.AbilityKit";
import { AppStorageV2, promptAction, window } from "@kit.ArkUI";
import { hsLog } from "@learn/logger_har";
import { Constants } from "../contants/Constants";
import { Banner } from "./view/Banner";
import { ArticleModel } from "./model/ArticleModel";
import { ArticlesList } from "./view/ArticlesList";
import { LIST_DATA } from "./model/GoodsMock";
import { YWAppUtils, YWValueWrapperV2 } from "@learn/common_har";
import { YWConstants } from "@learn/constants_har";

const TAG = "GoodsDetailPage"

@ComponentV2
export struct GoodsDetailPage {
  @Param @Require params:YWRouterNavParams
  @Local statusBarHeight: YWValueWrapperV2<number> = AppStorageV2.connect<YWValueWrapperV2<number>>(YWValueWrapperV2,YWConstants.kStatusBarHeight, ()=> new YWValueWrapperV2(0))!; // 顶部状态栏高度
  @Local navigateBarOpacity: number = 0; // 顶部状态栏透明度
  @Local isWhiteColor: boolean = true; // 状态栏是否为白色
  @Local isFlow: boolean = false; // 搜索框是否收起
  @Local negativeOffsetY: number = 0; // List向下拉到顶后继续上拉为负数的偏移量
  @Local isTop: boolean = false; // 是否通过按钮点击回到顶部
  @Local dataSource: HSDataSource<ArticleModel> = new HSDataSource();
  private scroller: ListScroller = new ListScroller();
  popPage: (() => void) | undefined = undefined;

  aboutToAppear(): void {
    // 设置沉浸模式及状态栏白色
    // YWAppUtils.setImmersive(this.popPage);
    //不隐藏顶部时间栏号一些
    YWAppUtils.setStatusBar(true,false)

    // 获取顶部状态栏高度
    YWAppUtils.getNavStatusBarHeight((statusBarHeight) => {
      hsLog.i(TAG, 'statusBarHeight is ' + statusBarHeight);
    })

    // 组装数据源
    this.dataSource.pushData(LIST_DATA);

    this.params.getPageLifecycleImp().setOnWillDisappear(()=>{
      YWAppUtils.setStatusBar(false,true)
    })
    this.params.getPageLifecycleImp().setOnBackPressed(()=>{
      YWAppUtils.setStatusBar(false,true)
      return false
    })
  }

  aboutToDisappear(): void {
    // YWAppUtils.deleteEmitter();
    YWAppUtils.setStatusBar(false,true)
  }

  /**
   * 搜索框提示字
   */
  @Builder
  articleTitleBuilder() {
    Text('相关商品')
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyHeiTi-Bold')
      .fontSize(17)
      .width('100%')
      .height('40vp')
      .padding({
        left: '12vp',
        top: '10vp'
      })
      .backgroundColor($r('app.color.bg_gray_base'))
  }

  /**
   * 定位和天气
   */
  @Builder
  locationAndWeatherBuilder() {
    Column() {
      Text('长沙')
        .textAlign(TextAlign.Center)
        .fontSize(17)
        .fontColor(this.isWhiteColor ? '#FFFFFF' : '#B3000000')
        .fontWeight(FontWeight.Bold)
        .width(50)
        .height(25)

      Text("热")
        .textAlign(TextAlign.Center)
        .fontSize(13)
        .fontColor(this.isWhiteColor ? '#FFFFFF' : '#B3000000')
        .fontWeight(FontWeight.Bold)
        .width(50)
        .height(15)
    }
    .onClick(() => {
      promptAction.showToast({
        message: '待完善'
      });
    })
    .padding({
      left: '5vp'
    })
    .zIndex(1)
  }

  /**
   * 展开后的蓝色回顶部图标
   */
  @Builder
  topUpBuilder() {
    Column() {
      Image($r("app.media.status_bar_animation_top_up"))
        .width($r('app.integer.status_bar_animation_top_up_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)

      Text($r('app.string.status_bar_animation_top_up_text'))
        .textAlign(TextAlign.Center)
        .fontSize($r('app.integer.status_bar_animation_top_up_text_font'))
        .fontColor($r("app.color.status_bar_animation_text_black"))
        .width($r('app.integer.status_bar_animation_top_up_text_width'))
        .height($r('app.integer.status_bar_animation_top_up_text_height'))
    }
    .onClick(() => {
      this.isTop = true;
      // 点击回顶部按钮列表回滚到顶部
      setTimeout(()=> {
        this.scroller.scrollTo({
          xOffset: Constants.MAIN_SCROLLER_OFFSET_X,
          yOffset: Constants.MAIN_SCROLLER_OFFSET_Y,
          animation: {
            duration: Constants.ANIMATION_DURATION1,
            curve: Curve.FastOutLinearIn
          }
        })
      },Constants.ANIMATION_DURATION)


    })
    .padding({
      left: $r('app.integer.status_bar_animation_top_up_padding_left')
    })
    .zIndex(Constants.Z_INDEX_ONE)
  }

  /**
   * 展开和收起的动效视图
   */
  @Builder
  searchViewBuilder() {
    Row() {
      // 爱心图标
      Image($r("app.media.status_bar_animation_favor"))
        .width($r('app.integer.status_bar_animation_favor_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: Constants.FAVOR_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal,
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 圆圈五星图标
      Image($r("app.media.status_bar_animation_highlight"))
        .width($r('app.integer.status_bar_animation_highlight_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: this.isFlow ? Constants.HIGHLIGHT_POSITION_X2 : Constants.HIGHLIGHT_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 五星图标
      Image($r("app.media.status_bar_animation_collected"))
        .width($r('app.integer.status_bar_animation_collected_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: this.isFlow ? Constants.COLLECTED_POSITION_X2 : Constants.COLLECTED_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 搜索图标
      Row() {
        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_search_white") :
        $r("app.media.status_bar_animation_search_black"))
          .width($r("app.integer.status_bar_animation_search_image_width"))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
          .margin({
            left: $r("app.integer.status_bar_animation_search_image_margin_left")
          })

        Text($r('app.string.status_bar_animation_search_text'))
          .fontSize($r('app.integer.status_bar_animation_search_text_font'))
          .fontColor(this.isWhiteColor ? $r("app.color.status_bar_animation_search_title_white") :
          $r("app.color.status_bar_animation_search_title_black"))
          .layoutWeight(Constants.LAYOUT_WEIGHT)
          .height($r('app.integer.status_bar_animation_search_text_height'))
          .margin({ left: $r('app.integer.status_bar_animation_search_text_margin_left') })
          .wordBreak(WordBreak.NORMAL)
          .clip(true)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })
      .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
      $r("app.color.status_bar_animation_background_white"))
      // 搜索框的borderRadius圆角变化
      .borderRadius(this.isFlow ? Constants.SEARCH_BORDER_RADIUS2 :
      Constants.SEARCH_BORDER_RADIUS1)
      .height($r('app.integer.status_bar_animation_search_height'))
      .width(this.isFlow ?
      $r('app.integer.status_bar_animation_search_width') : Constants.FULL_PERCENT)
      // TODO: 知识点：设置搜索框右侧position为0，使搜索图标展开和收起靠右侧。（默认靠左侧）
      .position({
        right: Constants.SEARCH_POSITION_RIGHT
      })
      // 搜索框添加属性动画
      .animation({
        duration: Constants.ANIMATION_DURATION1,
        curve: Curve.Linear,
        playMode: PlayMode.Normal
      })
    }
    .margin({
      left: $r('app.integer.status_bar_animation_search_margin_left'),
      right: $r('app.integer.status_bar_animation_search_margin_right')
    })
    .layoutWeight(Constants.LAYOUT_WEIGHT)
    .height($r('app.integer.status_bar_animation_search_height'))
  }

  /**
   * 灰色背景的功能视图
   */
  @Builder
  toolViewBuilder() {
    Row({ space: Constants.TOOL_VIEW_SPACE }) {
      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
          $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SHARE_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_share_width'))
          .height($r('app.integer.status_bar_animation_share_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_share_white") :
        $r("app.media.status_bar_animation_share_black"))
          .width($r('app.integer.status_bar_animation_share_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })

      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
          $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SCAN_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_scan_width'))
          .height($r('app.integer.status_bar_animation_scan_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_scan_white") :
        $r("app.media.status_bar_animation_scan_black"))
          .width($r('app.integer.status_bar_animation_scan_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })

      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
          $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SETTING_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_setting_width'))
          .height($r('app.integer.status_bar_animation_setting_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_setting_white") :
        $r("app.media.status_bar_animation_setting_black"))
          .width($r('app.integer.status_bar_animation_setting_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })
    }
    .width($r('app.integer.status_bar_animation_tool_view_width'))
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Row() {
        // 动态显示回顶部或位置天气控件
        if (this.isFlow) {
          this.topUpBuilder();
        } else {
          this.locationAndWeatherBuilder();
        }
        this.searchViewBuilder();
        this.toolViewBuilder();
      }
      .height(Constants.NAVIGATION_BAR_HEIGHT + this.statusBarHeight.value)
      .width(Constants.FULL_PERCENT)
      .padding({
        top: this.statusBarHeight.value
      })
      .zIndex(Constants.Z_INDEX_THREE)

      // TODO: 知识点：父组件的透明度Opacity影响子组件（如父类Opacity为0.5，若子组件为0.5时，子组件实际Opacity = 0.5*0.5）,此处Row来改变状态栏的透明度不受影响其它组件透明度
      Row() {
      }
      .backgroundColor($r("app.color.status_bar_animation_white"))
      .opacity(this.navigateBarOpacity)
      .height(Constants.STATUS_BAR_HEIGHT + this.statusBarHeight.value)
      .width(Constants.FULL_PERCENT)
      .zIndex(Constants.Z_INDEX_TWO)

      List({ scroller: this.scroller }) {
        ListItem() {
          Banner({ increaseBannerHeight: this.negativeOffsetY });
        }

        ListItemGroup({ header: this.articleTitleBuilder() }) {
          // 加载列表
          ArticlesList({ listData: this.dataSource, isTop: this.isTop });
        }
      }
      .id('statusbar_animation_main_list')
      // 隐藏滚动条
      .scrollBar(BarState.Off)
      // 渐变蓝色背景色
      .linearGradient({
        colors: [[Constants.LIST_LINEAR_GRADIENT_START_COLOR, Constants.LIST_LINEAR_GRADIENT_START],
          [Constants.LIST_LINEAR_GRADIENT_END_COLOR, Constants.LIST_LINEAR_GRADIENT_END]]
      })
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)

      // TODO: 性能知识点：onDidScroll属于高频回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
      .onDidScroll(() => {
        // TODO: 知识点：通过currentOffset来获取偏移量比较准确。
        const yOffset: number = this.scroller.currentOffset().yOffset;

        // 偏移量为负值Banner会有拉伸放大效果
        yOffset <= Constants.MAIN_SCROLLER_OFFSET_Y_ZERO ? this.negativeOffsetY = yOffset :
        Constants.MAIN_SCROLLER_OFFSET_Y_ZERO;

        // 判断导航栏和状态栏背景透明度变化
        yOffset >= Constants.MAIN_SCROLLER_OFFSET_Y_MAX + this.statusBarHeight.value ?
          this.navigateBarOpacity = Constants.NAVIGATION_BAR_OPACITY_MAX :
          this.navigateBarOpacity = yOffset / Constants.MAIN_SCROLLER_OFFSET_Y_MAX;

        // 判断当前的导航栏和图标颜色变化
        yOffset > this.statusBarHeight.value ?
          this.isWhiteColor = false : this.isWhiteColor = true;

        // 判断状态栏字体颜色变化
        yOffset > this.statusBarHeight.value ?
        YWAppUtils.setSystemBarContentColor(Constants.StatusBarContentBlackColor) :
        YWAppUtils.setSystemBarContentColor(Constants.StatusBarContentWhiteColor);

        // 判断导航栏动效变化
        yOffset >= this.statusBarHeight.value + Constants.MAIN_SCROLLER_OFFSET_STATUS_CHANGE ?
          this.isFlow = true : this.isFlow = false
      })
    }
    .zIndex(Constants.Z_INDEX_ONE)
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
  }
}

//odd测试数据 ToDo 调试
export function goodsDetailBuilder(name?: string, params?:YWRouterNavParams) {
  GoodsDetailPage({params})
}

@Builder
export function goodsDetailNavBuilder(name?: string, params?:YWRouterNavParams) {
  NavDestination(){
    GoodsDetailPage({params})
  }
  .hideTitleBar(true)
  .onWillDisappear(()=>{
    params?.getPageLifecycle().pageOnWillDisappear?.()
  })
  .onBackPressed(()=>{
    return params?.getPageLifecycle().onBackPressed?.() ?? false
  })
}

ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_TAB,[
  {name:YWNavPath.root_goods_detail_nav, builder: wrapBuilder(goodsDetailNavBuilder)},
])
