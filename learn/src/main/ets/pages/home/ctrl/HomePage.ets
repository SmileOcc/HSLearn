import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants';
import Logger from '../../../../../../../modules/common_har/src/main/ets/common/KLogger';
import RouterUtils from '../../../../../../../modules/common_har/src/main/ets/utils/RouterUtils';
import { promptAction, router, window } from '@kit.ArkUI';
import { bundleManager, common } from '@kit.AbilityKit';
import { HWTTLogger } from 'STHarLib';
import SearchComponent from '../view/SearchComponent';
import SwiperComponent from '../view/SwiperComponent';
import { GridComponent } from '../view/GridComponent';
import { GoodsTabComponent } from '../view/GoodsTabComponent';
import { GoodsDetailComponent } from '../view/GoodsDetailComponent';
import { ThemeManager } from '../../../../../../../modules/common_har/src/main/ets/utils/ThemeManager';

const SCROLL_OFFSET_FULL: number = 120;
const BACKGROUND_HEIGHT: Length = 222;

@Extend(Navigation)
function setNavStyle() {
  .hideTitleBar(true)
  .width(Constants.FULL_WIDTH)
  .height(Constants.FULL_HEIGHT)
}

@Extend(Tabs)
function setTabStyle() {
  .barHeight(0)
  .scrollable(false)
}

@Entry
@Component
export struct HomePage {
  @Provide('NavPathStack') pageInfos: NavPathStack = new NavPathStack();
  @State message: string = 'Hello World';
  @State isRefreshing: boolean = false;
  @State arr: String[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  @State bgOpacity: number = 1;
  private scroller: Scroller = new Scroller();

  private context = getContext(this) as common.UIAbilityContext;
  aboutToAppear(): void {
    //获取版本号
    //  Constants.getAppVersion().then((ver)=>{
    //    this.message = ver
    // })

    Logger.debug("获取版本号1：" )

    //异步方式获取
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then((bundleInfo) => {
        let versionName: string = bundleInfo.versionName; //应用版本名
        let versionNo: string = bundleInfo.versionCode.toString(); //应用版本号
        this.message = "v" + versionName + "." + versionNo
      }).catch((error:Error) => {
      Logger.error("获取版本号异常：" + error)
    })

    getContext(this).eventHub.on(Constants.EVENT_QUICK_TOP_FUNC, (): void => {
      this.scroller.scrollTo({ xOffset: 0, yOffset: 0 });
      this.bgOpacity = 1;
      getContext(this).eventHub.emit(Constants.EVENT_TOP_ICON, false);
    })

    //页面中设置setWindowLayoutFullScreen
    // window.getLastWindow(getContext())
    //   .then(win => {
    //     win.setWindowLayoutFullScreen(true)
    //   })
  }

  onPageHide() {
    // window.getLastWindow(getContext())
    //   .then(win => {
    //     win.setWindowLayoutFullScreen(false)
    //   })

    Logger.debug("onPageHide：" )

    ThemeManager.settingStatusBarWhite()
  }

  onPageShow() {
    Logger.debug("onPageShow： 不会触发，在index 里" )
    // window.getLastWindow(getContext())
    //   .then(win => {
    //     win.setWindowLayoutFullScreen(true)
    //   })

    ThemeManager.settingStatusBarBlack()


    let applicationContext = this.context.getApplicationContext();
    let cacheDir = applicationContext.cacheDir;//<路径前缀>/<加密等级>/base/cache
    let tempDir = applicationContext.tempDir;
    let filesDir = applicationContext.filesDir;
    let databaseDir = applicationContext.databaseDir;
    let bundleCodeDir = applicationContext.bundleCodeDir;
    let distributedFilesDir = applicationContext.distributedFilesDir;
    let preferencesDir = applicationContext.preferencesDir;

    // 获取应⽤⽂件路径
    let filePath = tempDir + 'test.txt';
    Logger.debug(`filePath: ${filePath}`);
    if (filePath !== null) {
      promptAction.showToast({
        message: filePath
      });
    }
  }

  @Builder
  PagesMap(name: string, param: number) {
    if (name === 'Detail') {
      GoodsDetailComponent()
    }
  }

  build() {
    Navigation(this.pageInfos) {

      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.ic_app_background'))
          .width(Constants.FULL_WIDTH)
          .height(BACKGROUND_HEIGHT)
          .objectFit(ImageFit.Fill)
          .opacity(this.bgOpacity)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        Column() {
          SearchComponent()
          Refresh({ refreshing: $$this.isRefreshing }) {
            Scroll(this.scroller) {
              Column() {
                SwiperComponent()
                GridComponent()
                GoodsTabComponent()
              }
            }
            .width(Constants.FULL_WIDTH)
            .height(Constants.FULL_HEIGHT)
            .scrollBar(BarState.Off)
            .scrollable(ScrollDirection.Vertical)
            // .onWillScroll((handler) => {
            //   let opacity = (SCROLL_OFFSET_FULL - this.scroller.currentOffset().yOffset) * 1.0 / SCROLL_OFFSET_FULL;
            //   if (opacity <= 0) {
            //     this.bgOpacity = 0;
            //   } else {
            //     this.bgOpacity = opacity;
            //   }
            //   getContext(this).eventHub.emit(Constants.EVENT_TOP_ICON, (this.bgOpacity <= 0) ? true : false);
            // })
            .padding({
              top: $r('app.float.refresh_padding_top'),
            })
          }
          .onRefreshing(() => {
            setTimeout(() => {
              getContext(this).eventHub.emit(Constants.EVENT_REFRESH_WATERFLOW_DATA, null);
              this.isRefreshing = false;
            }, Constants.TIME_OUT_TWO_THOUSANDS)
          })
        }
        .height(Constants.FULL_HEIGHT)

      }
      .height(Constants.FULL_HEIGHT)
      .backgroundColor($r('app.color.home_background_color'))

    }
    //.toolbarConfiguration(this.ToolBarBuilder())
    .setNavStyle()
    .navDestination(this.PagesMap)

  }

  // build() {
  //   Row() {
  //     Column() {
  //       Row(){
  //         // TextInput({placeholder:'请输入搜索内容'})
  //         //   .backgroundColor(Constants.COLOR_EEEEEE)
  //         //   .fontSize(14)
  //         //   .borderRadius(8)
  //         //   .height(40)
  //         //   .layoutWeight(8)
  //         //   .enabled(false)
  //         //   .onClick(()=>{
  //         //     Logger.debug('==== 搜索')
  //         //   })
  //
  //         Text('请输入搜索内容')
  //           .backgroundColor(Constants.COLOR_EEEEEE)
  //           .fontSize(14)
  //           .borderRadius(20)
  //           .height(40)
  //           .layoutWeight(8)
  //           .padding({left:8})
  //           .onClick(()=>{
  //             Logger.debug('==== 搜索')
  //             RouterUtils.jumpRouter('pages/search/SearchPage')
  //
  //           })
  //
  //         Blank().width(12)
  //         Button('搜索')
  //           .buttonStyle(ButtonStyleMode.TEXTUAL)
  //           .fontColor(Constants.COLOR_333333)
  //           .fontSize(16)
  //           .onClick(()=>{
  //
  //             let tttLogger = new HWTTLogger()
  //
  //             tttLogger.debug('==== 搜索1')
  //
  //             RouterUtils.jumpRouter('pages/search/SearchResultPage')
  //           })
  //           .layoutWeight(2)
  //           .height(30)
  //           .backgroundColor(Color.White)
  //       }
  //       .alignItems(VerticalAlign.Center)
  //       // .justifyContent(FlexAlign.SpaceBetween)
  //       .backgroundColor(Color.White)
  //       .height(59)
  //       .padding({left:16,right:16})
  //
  //       Blank().height(12)
  //       Text(this.message)
  //         .fontSize(50)
  //         .fontWeight(FontWeight.Bold)
  //     }
  //     .height('100%')
  //     .width('100%')
  //     .justifyContent(FlexAlign.Start)
  //   }
  //   .height('100%')
  //   .backgroundColor(Constants.COLOR_EEEEEE)
  //
  // }
}