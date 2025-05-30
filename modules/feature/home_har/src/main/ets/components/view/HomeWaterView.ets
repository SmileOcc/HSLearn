import { HSLazyDataSource } from "@learn/base_model_har";
import { YWConstants } from "@learn/constants_har";
import { HomeAdvModel } from "../model/HomeAdvModel";
import { HomeTabModel } from "../model/HomeTabItem";
import { display, promptAction } from "@kit.ArkUI";
import { connection } from "@kit.NetworkKit";
import { ywNavRouter } from "@learn/nav_router_har";
import { HomeAdvArticleList } from "./HomeAdvArticle/HomeAdvArticle";

/**
 * 主页瀑布流列表
 */
@Component
export struct HomeWaterView {
  // @Link listData: HomeAdvModel[];
  // dataSource: HSLazyDataSource = new HSLazyDataSource(this.listData);
  dataSource: HSLazyDataSource = new HSLazyDataSource([]);

  @State tabsIndex: number = 0;
  @State tabColumns: string = '1fr 1fr';
  tabsController: TabsController = new TabsController();
  private scrollController: Scroller = new Scroller();
  isFoldable: boolean | undefined = AppStorage.get(YWConstants.kIsFoldable);
  @Provide itemWidth: number = 0

  @State tabData: HomeTabModel[] = [
    new HomeTabModel(0, '全部'),
    new HomeTabModel(1, '热门'),
    new HomeTabModel(2, '推荐'),
    new HomeTabModel(3, '精选'),
    new HomeTabModel(4, '浏览'),
    new HomeTabModel(5, '历史'),
    new HomeTabModel(6, '热点新闻'),
    new HomeTabModel(7, '其他'),
  ]

  testMockData() {
    for(let item of this.tabData) {
      for (let i=0; i<50; i++) {
        let tempAdvModel: HomeAdvModel = new HomeAdvModel(`cid_${item.id}_${i}`)
        tempAdvModel.title = `title_${item.navData}`
        tempAdvModel.bgColor = YWConstants.RandomColor()
        tempAdvModel.linkUrl = "applink:"
        tempAdvModel.type = item.navData
        tempAdvModel.ratio = i % 3 == 0 ? 4/3 : 1
        this.dataSource.pushData(tempAdvModel)
      }

    }
  }

  aboutToAppear(): void {
    // 34为左右边距+两个瀑布流中间的距离
    this.itemWidth = (AppStorage.get(YWConstants.kStorageWidth) as number - 34) / 2

    this.testMockData()
  }

  @Builder
  tabBuilder(index: number, name: string | undefined) {
    Stack() {
      Column() {
      }
      .width(this.tabsIndex === index ? $r('app.integer.functional_scenes_tab_bar_background_width1') :
      $r('app.integer.functional_scenes_tab_bar_background_width2'))
      .backgroundColor(this.tabsIndex === index ? '#0A59F7' : '#000000')
      .opacity(this.tabsIndex === index ? 1 : 0.05)
      .height($r('app.integer.functional_scenes_tab_bar_background_height'))
      .borderRadius($r('app.integer.functional_scenes_tab_bar_background_border_radius'))

      Text(name)
        .fontSize($r('app.string.ohos_id_text_size_body1'))
        .fontColor(this.tabsIndex === index ? Color.White : Color.Black)
        .opacity(this.tabsIndex === index ? 1 : 0.8)
        .height('100%')
        .id('section')
    }
    .margin(index !== 0 && index !== this.tabData.length ? { left: $r('app.integer.functional_scenes_tab_bar_margin') } : {
      left: 0,
      right: 0
    })
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  @Builder
  tabsMenu() {
    Menu() {
      ForEach(this.tabData, (item: HomeTabModel) => {
        MenuItem({ content: item.navData })
          .onClick(() => {
            this.tabsIndex = item.id;
            this.tabsController.changeIndex(item.id);
          })
          .id('menu_item')
      })
    }
  }

  /**
   * 主页通过瀑布流和LazyForeach加载
   * WaterFlow+LazyForEach详细用法可参考性能范例：
   * https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/waterflow_optimization.md/
   */
  build() {
    Column() {
      Row() {
        Stack() {
          List({ scroller: this.scrollController }) {
            ForEach(this.tabData, (tabItem: HomeTabModel) => {
              ListItem() {
                this.tabBuilder(tabItem.id, tabItem.navData);
              }
            })
          }
          .id("MainList")
          .margin({ top: $r('app.integer.functional_scenes_tab_bar_list_margin') })
          .height($r('app.integer.functional_scenes_tab_bar_list_height'))
          .listDirection(Axis.Horizontal)
          .padding({ right: $r('app.integer.functional_scenes_tab_bar_list_padding') })
          .scrollBar(BarState.Off)

          Row() {
            Row() {
              Image($r("app.media.ic_public_more"))
                .width($r('app.integer.functional_scenes_tab_bar_image_more'))
                .id('mainPageTabsImage')
            }
            .bindMenu(this.tabsMenu)
            .justifyContent(FlexAlign.Center)
            .width($r('app.integer.functional_scenes_tab_bar_image_more_background_size'))
            .height($r('app.integer.functional_scenes_tab_bar_image_more_background_size'))
            .borderRadius($r('app.integer.functional_scenes_tab_bar_image_more_border_radius'))
            .backgroundColor('#D8D8D8')
            .id('menu_button')
          }
          .linearGradient({
            angle: 90,
            colors: [['rgba(241, 241, 241, 0)', 0], ['#F1F3F5', 0.2], ['#F1F3F5', 1]]
          })
          .justifyContent(FlexAlign.End)
          .width($r('app.integer.functional_scenes_tab_bar_image_more_row_width'))
          .height($r('app.integer.functional_scenes_tab_bar_image_more_row_height'))
        }
        .alignContent(Alignment.TopEnd)
      }
      .padding({
        left: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding'),
        right: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding')
      })
      .margin({ top: $r('app.integer.functional_scenes_tab_bar_image_more_row_margin') })

      Tabs({ controller: this.tabsController }) {
        ForEach(this.tabData, (tabItem: HomeTabModel) => {
          TabContent() {
            if (tabItem.navData !== '热点新闻') {
              WaterFlow() {
                LazyForEach(this.dataSource, (waterFlowItem: HomeAdvModel) => {
                  FlowItem() {
                    if (tabItem.navData === '全部' || tabItem.navData === waterFlowItem.type) {
                      methodPoints({ listData: waterFlowItem })
                    }
                  }
                }, (waterFlowItem: HomeAdvModel) => JSON.stringify(waterFlowItem))
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .cachedCount(1)
              .columnsTemplate(this.tabColumns)
              .columnsGap($r('app.string.functional_scenes_main_page_water_flow_gap'))
              .width('100%')
              .clip(false)
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
              .padding({ bottom: $r('app.integer.functional_scenes_water_flow_padding_bottom') })
            } else {
              Scroll() {
                HomeAdvArticleList()
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .scrollBar(BarState.Off)
              .clip(false)
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
              .padding({ bottom: $r('app.integer.functional_scenes_water_flow_padding_bottom') })
            }
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          .align(Alignment.TopStart)
          .alignSelf(ItemAlign.Start)
        })
      }
      .margin({ top: $r('app.integer.functional_scenes_tab_bar_image_more_row_margin') })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .padding({
        left: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding'),
        right: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding')
      })
      .height('100%')
      .barWidth(0)
      .barHeight(0)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.tabsIndex = targetIndex;
        this.scrollController.scrollToIndex(targetIndex, true, ScrollAlign.START);
      })
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        if (_oldValue.width === newValue.width) {
          return;
        }
        // TODO：知识点：组件区域变化后根据窗口宽度和折叠屏折叠态计算瀑布流展示item列数
        // 折叠屏下item显示宽度
        let foldableWidth =
          getContext(this).resourceManager.getNumber($r('app.integer.functional_scenes_item_foldable_width'));
        // 其他情况下item显示宽度
        let itemWidth = getContext(this).resourceManager.getNumber($r('app.integer.functional_scenes_item_width'));
        // 根据屏幕宽度计算展示item列数
        let maxItemCount = Math.floor(Number(newValue.width) / (this.isFoldable ? foldableWidth : itemWidth));
        this.tabColumns = '1fr' + ' 1fr'.repeat(maxItemCount - 1);
      })
    }
    .height('100%')
    .backgroundColor("#F1F1F1")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

/**
 * 瀑布流列表项组件布局
 *
 * @param listData 组件列表信息
 */
// TODO:知识点：
// 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
// 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。
@Reusable
@Component
struct methodPoints {
  @State listData: HomeAdvModel =
    new HomeAdvModel("cid_points");
  @State helperUrl: string = 'about://blank';
  @State screenW: number = AppStorage.get<number>(YWConstants.kStorageWidth) ?? 0;
  @State isNeedClear: boolean = false;
  private deviceSize: number = 600; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  // 当前屏幕折叠态（仅折叠屏设备下有效）
  curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  // 从AppStorage中获取设别类别，判断是否为折叠屏
  isFoldable: boolean | undefined = AppStorage.get('isFoldable');
  @Consume itemWidth: number;
  @State @Watch("onShowReadMeChange") isShowReadMe: boolean = false;

  aboutToAppear(): void {
    if (display.isFoldable()) {
      this.regDisplayListener();
    } else {
      if (this.screenW >= this.deviceSize) {
        this.isNeedClear = true;
      } else {
        this.isNeedClear = false;
      }
    }
  }

  /**
   * 组件的生命周期回调，在可复用组件从复用缓存中加入到组件树之前调用
   * @param params：组件更新时所需参数
   */
  aboutToReuse(params: Record<string, HomeAdvModel>): void {
    this.listData = params.listData as HomeAdvModel;
  }

  /**
   * 注册屏幕状态监听 (仅限折叠屏)
   * @returns {void}
   */
  regDisplayListener(): void {
    this.changeNeedClear(display.getFoldStatus());
    display.on('foldStatusChange', async (curFoldStatus: display.FoldStatus) => {
      // 同一个状态重复触发不做处理
      if (this.curFoldStatus === curFoldStatus) {
        return;
      }
      // 缓存当前折叠状态
      this.curFoldStatus = curFoldStatus;
      this.changeNeedClear(this.curFoldStatus);
    })
  }

  changeNeedClear(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isNeedClear = false;
    } else {
      this.isNeedClear = true;
    }
  }

  changeHelpUrl(): void {
    this.helperUrl = this.listData.url ?? "";
  }

  getNNWeb(url: string) {

  }

  onShowReadMeChange(): void {
    if (!this.isShowReadMe) {
      // 半模态弹窗关闭时，加载空白页面，防止主页瀑布流源码页面显示混乱
      // getNWeb('about://blank'); //TODO
      this.getNNWeb('about://blank')
    }
  }

  // 帮助功能：半模态弹窗显示对应案例README
  @Builder
  buildReadMeSheet(): void {
    Column() {
      Row() {
        Row() {
          Text(this.listData.title ?? "")
            .textOverflow({ overflow: TextOverflow.Clip })
            .fontColor(Color.White)
            .fontWeight(700)
            .fontSize($r('app.integer.nav_destination_title_text_size'))
        }
        .width($r('app.integer.readme_sheet_text_size'))

        Column() {
          Stack() {
            Column() {
            }
            .width($r('app.integer.readme_sheet_size'))
            .height($r('app.integer.readme_sheet_size'))
            .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
            .backgroundColor(Color.White)
            .opacity(0.05)

            Image($r('app.media.ic_public_cancel'))
              .fillColor(Color.White)
              .width($r('app.integer.readme_sheet_cancel_image_width'))
          }
        }
        .onClick(() => {
          this.isShowReadMe = false;
        })
        .justifyContent(FlexAlign.Center)
        .width($r('app.integer.readme_sheet_size'))
        .height($r('app.integer.readme_sheet_size'))
        .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
      }
      .padding({ left: $r('app.integer.readme_sheet_padding'), right: $r('app.integer.readme_sheet_padding') })
      .margin({ top: $r('app.integer.readme_sheet_margin'), })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      // NodeContainer(getNWeb(this.helperUrl))
      //   .width('100%')
      //   .height('100%')
      //   .onAppear(() => {
      //     this.changeHelpUrl();
      //   })
      //TODO
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {

        if (this.listData.ratio) {
          Image(this.listData.imageUrl)
            .borderRadius({
              topLeft: $r('app.string.functional_scenes_main_page_list_borderRadius'),
              topRight: $r('app.string.functional_scenes_main_page_list_borderRadius'),
              bottomLeft: 0,
              bottomRight: 0
            })
            .objectFit(ImageFit.Contain)
            .width('100%')
          .aspectRatio(this.listData.ratio)
            .backgroundColor(this.listData.bgColor ?? Color.White)

        } else {
          Image(this.listData.imageUrl)
            .borderRadius({
              topLeft: $r('app.string.functional_scenes_main_page_list_borderRadius'),
              topRight: $r('app.string.functional_scenes_main_page_list_borderRadius'),
              bottomLeft: 0,
              bottomRight: 0
            })
            .objectFit(ImageFit.Contain)
            .width('100%')
            .backgroundColor(this.listData.bgColor ?? Color.White)

        }
      Text(this.listData.type + '. ' + this.listData.title)
        .padding({
          left: $r('app.string.functional_scenes_main_page_padding6'),
          right: $r('app.string.functional_scenes_main_page_padding6')
        })
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .fontSize($r('app.string.ohos_id_text_size_body1'))
        .margin({
          top: $r('app.string.functional_scenes_main_page_margin1'),
          bottom: $r('app.string.functional_scenes_main_page_margin1')
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row() {
        Button() {
          Text($r('app.string.functional_scenes_readme'))
            .fontSize($r('app.integer.functional_scenes_readme_font_size'))
            .fontColor(Color.White)
        }
        .height($r('app.integer.functional_scenes_readme_height'))
        .width($r('app.integer.functional_scenes_readme_width'))
        .margin({ left: 6, right: 10 })
        .gesture(
          GestureGroup(
            GestureMode.Exclusive,
            TapGesture({ fingers: 1, count: 1 })
              .onAction(() => {
                if (connection.hasDefaultNetSync()) {
                  this.isShowReadMe = !this.isShowReadMe;
                } else {
                  promptAction.showToast({ message: $r("app.string.functional_scenes_network_message") });
                }
              })
          )
        )
        .bindSheet($$this.isShowReadMe, this.buildReadMeSheet(), {
          detents: [SheetSize.MEDIUM, SheetSize.LARGE],
          showClose: false,
          dragBar: true,
          backgroundColor: $r("app.color.helper_bindsheet_bgc"),
          preferType: SheetType.CENTER,
          // 设置为false时不允许与背景页面交互，显示蒙层
          enableOutsideInteractive: false,
          // 设置半模态高度变化过程中持续更新内容
          scrollSizeMode: ScrollSizeMode.CONTINUOUS
        })
        Text($r('app.string.functional_scenes_difficulty'))
          .fontColor(Color.Black)
          .opacity(0.6)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .height($r('app.string.functional_scenes_main_page_text_height'))
          .fontSize($r('app.string.functional_scenes_main_page_text_font_size'))
          .width($r('app.string.functional_scenes_main_page_text_width'))
        Rating({
          rating: this.listData.ratingNumber,
          indicator: true
        })
          .stars(5)
          .width($r('app.integer.functional_scenes_rating_width'))
      }
      .margin({ bottom: $r('app.string.functional_scenes_main_page_padding6') })
      .width($r('app.string.functional_scenes_full_size'))
      .justifyContent(FlexAlign.Start)
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .backgroundColor(Color.White)
    .width(this.isFoldable ? $r('app.integer.functional_scenes_item_foldable_width') :
    this.itemWidth)
    .borderRadius($r('app.string.functional_scenes_main_page_list_borderRadius'))
    .margin({
      top: $r('app.string.functional_scenes_item_gap_half'),
      bottom: $r('app.string.functional_scenes_item_gap_half')
    })
    .onClick(() => {
      // 判断当前路由栈最后一个路由是否与当前跳转路由相同,相同则不跳转
      // if (DynamicsRouter.appRouterStack.slice(-1)[0].name === this.listData.appUri) {
      //   return;
      // }
      // // 平板采用点击切换案例，需要pop，手机则不需要，左滑时已pop。
      // if (this.isNeedClear) {
      //   DynamicsRouter.clear();
      // }
      if (this.listData !== undefined) {
        // 点击瀑布流Item时，根据点击的模块信息，将页面放入路由栈
        // FoldableRouter.pushUri(this.listData.appUri, this.listData.param);
        ywNavRouter.openRoute(this.getUniqueId())
          .onTargetUrl(this.listData.linkUrl ?? "")
          .onRouteMode()
          .go()
      }
    })
  }
}

