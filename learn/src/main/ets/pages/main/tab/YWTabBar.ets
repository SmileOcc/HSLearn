/*
 * @Desc: 自定义底部栏
 * @Author: qincji
 * @Address: https://gitee.com/qincji/ZeroOneApp
 * @Date: 2024/5/18
 */
import { YWAvoidAreas, getDefaultAvoidAreas } from '@learn/common_har';
import { getAvoidPadding } from '@learn/common_har/src/main/ets/windowUtils/YWAvoidAreas';
import { YWConstants } from '@learn/constants_har';
import { YWTabItem } from './YWTabItem'

@Component
export struct YWTabBar {

  @StorageLink(YWConstants.kStorageAreas) @Watch('onAreasChange') avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()

  @Prop data: Array<YWTabItem>;
  @BuilderParam page: (index: number) => void;
  @BuilderParam itemBuilder: (item: YWTabItem, index: number) => void = this.tabBuilder;
  onListener?: (index: number) => void;
  tabHeight: number | string | Resource = $r('app.float.height_tab');
  txtSize: number | string | Resource = $r('app.float.font_main');
  txtNormalColor: ResourceColor = $r('app.color.main');
  txtSelectColor: ResourceColor = $r('app.color.theme_light');
  imgNormalSize: Length = $r('app.float.size_tab_icon_normal');
  imgSelectSize: Length = $r('app.float.size_tab_icon_select');
  tabAttrModifier: AttributeModifier<TabsAttribute> = {};
  tabsController: TabsController = new TabsController();
  @Link @Watch('onSelectIndex') selectIndex: number;

  aboutToAppear(): void {

    let kkk = AppStorage.get(YWConstants.kStorageAreas) as YWAvoidAreas
    let safeH = getAvoidPadding(this.avoidAreas).bottom
  }

  onAreasChange() {

  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: 0, controller: this.tabsController }) {
      ForEach(this.data, (item: YWTabItem, index: number) => {
        TabContent() {
          this.page(index)
        }
        .width('100%')
        .height('100%')
        .tabBar(this.itemBuilder(item, index))
      })
    }
    .scrollable(false)
    // .backgroundColor(Color.White)
    .barHeight(this.tabHeight)
    // .margin({bottom:getAvoidPadding(this.avoidAreas).bottom})
    .animationDuration(0) //关闭动画
    .attributeModifier(this.tabAttrModifier)
    .onChange((index: number) => {
      this.selectIndex = index;
      this.onListener?.(index)
    })
  }

  @Builder
  tabBuilder(item: YWTabItem, index: number) {
    Column() {
      Image(this.selectIndex === index ? item.srcSelect : item.srcNormal)
        .size(this.selectIndex === index
          ? { width: this.imgSelectSize, height: this.imgSelectSize }
          : { width: this.imgNormalSize, height: this.imgNormalSize }
        )
        .animation({ duration: 100, curve: "ease" })
      Text(item.name)
        .fontSize(14)
        .fontWeight(this.selectIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.selectIndex === index ? this.txtSelectColor : this.txtNormalColor)
        .margin({ top: 2 })
    }
    .width('100%')
    .height("100%")
    // .borderWidth({ top: 1 })
    // .borderColor('#DDDDDD')
    // .backgroundColor(Color.White)
    .justifyContent(FlexAlign.End)
    .padding({ top: 5, bottom: 5 })
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


  }

  private onSelectIndex(): void {
    this.tabsController.changeIndex(this.selectIndex)
  }
}