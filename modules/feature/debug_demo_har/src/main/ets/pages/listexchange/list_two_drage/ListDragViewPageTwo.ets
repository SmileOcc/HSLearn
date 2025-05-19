import { YWConstants } from "@learn/constants_har";
import { hsLog } from "@learn/logger_har";
import { AppInfo } from "./model/AppInfo";
import { DataSource } from "./model/DataSource"
import { unifiedDataChannel, uniformTypeDescriptor } from "@kit.ArkData";
import { BusinessError } from "@kit.BasicServicesKit";
import { componentUtils } from "@kit.ArkUI";
import { ItemInfo } from "@kit.MediaLibraryKit";

/**
 * 功能描述: 本示例使用position绝对定位实现应用内悬浮窗，并且通过animateTo结合curves动画曲线实现悬浮窗拖拽跟手和松手吸附边缘的弹性动画效果
 *
 * 推荐场景: 悬浮窗显示场景
 *
 * 核心组件:
 * 1. FloatWindowView
 *
 * 实现步骤：
 *  1. 悬浮窗组件使用Stack嵌套video布局，使用属性position绝对定位使组件悬浮，position使用Edges类型控制悬浮窗到父组件四条边的距离
 *  2. 初始化时悬浮窗的position属性设置top和right，让悬浮窗靠右
 *  3. 父组件添加onAreaChange回调，获取父组件的宽高
 *  4. 悬浮窗组件添加onTouchEvent回调，在手指按下时保存触摸点在窗口中的坐标，用于移动时悬浮窗位置的计算
 *  5. 手指移动时，获取触摸点相对于应用窗口左上角的X和Y坐标，通过计算设置悬浮窗的position坐标实现拖拽，使用默认参数的弹性跟手动画曲线curves.responsiveSpringMotion结合animateTo实现跟手动画效果
 *  6. 手指抬起时，通过判断悬浮窗中心在水平方向位于父组件中心的左侧或右侧设置悬浮窗靠左或靠右，如果悬浮窗超出内容区上下边界，则将悬浮窗设置在边界位置，使用curves.springMotion弹性动画曲线实现吸附边界时的弹性动画效果
 */

const ICON_NUM_IN_LIST: number = 9; // 示例List中子组件数目
const LIST_SPACE: number = 0; // 列表默认间隔

const TAG = "ListSceneViewTwo"

@Builder
export function TestListDragViewTwoBuilder() {

  NavDestination() {
    ListerDragViewPageTwo()
  }
  .hideTitleBar(true)

}

@Component
export struct ListerDragViewPageTwo {
  build() {
    Column() {
      ListSceneViewTwo() // 实现List拖拽场景
    }
    .width($r("app.string.drag_and_exchange_layout_100_percent"))
    .height($r("app.string.drag_and_exchange_layout_100_percent"))
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r('app.media.drag_and_exchange_wallpaper_default'))
    .backgroundImageSize(ImageSize.Cover)
  }
}


/**
 * 实现List场景，拖拽交换子组件位置: 通过ListItem的onDragStart()方法指定拖拽开始时的行为，通过List的onTouch()指定拖拽释放时的行为。
 */
@Component
export struct ListSceneViewTwo {
  @State dataSource: DataSource = new DataSource();
  @State dragIndex: number = 0;
  private dragItem?: AppInfo
  private dragComponentInfo?: componentUtils.ComponentInfo
  @State backGroundColor: Color = Color.Transparent;
  @State moveItem: AppInfo | undefined = undefined

  aboutToAppear() {
    for (let index = 0; index < ICON_NUM_IN_LIST; index++) {
      this.dataSource.pushData(new AppInfo(`cid_${index}`, $r(`app.media.drag_and_exchange_ic_public_game${index + 1}`),
        `Item${index}`, true));
    }

    setTimeout(()=>{
      this.getAllComponentInfo()

    },2000)
  }

  changeIndex(index1: number, index2: number) {
    let temp: AppInfo = this.dataSource.getData(index1);
    this.dataSource.setData(index1, this.dataSource.getData(index2));
    this.dataSource.setData(index2, temp);
  }

  build() {
    Column() {
      // Text($r("app.string.drag_and_exchange_list_drag_title"))
      //   .fontColor(Color.White)
      //   .textAlign(TextAlign.Center)
      //   .fontSize($r("app.string.drag_and_exchange_opt_title_font_size"))
      // Text(`测试滑动的颜色: ${this.moveItem?.name}`)
      //   .backgroundColor(this.backGroundColor)
      //   .allowDrop([uniformTypeDescriptor.UniformDataType.TEXT])

      Row() { // 仅靠List实现背景框，padding调整样式后，互换时可能错位
        List({ space: LIST_SPACE }) {
          // TODO: 性能知识点：图标一次性完全显示，且禁用滑动，无需懒加载。LazyForEach可以适用在动态添加数据的场景中，参考资料：
          //  https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
          LazyForEach(this.dataSource, (item: AppInfo, index) => {
            ListItem() {
              Column() {
                IconNoNameView({ app: item })
              }
              .backgroundColor(Color.Gray)
              .width('100%')
            }
            .height('50vp')
            // .onAreaChange((oldValue: Area, newValue: Area) => {
            //   hsLog.d(TAG,`===onAreaChange: ${item.cid}<<<<Ace: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
            // })
            .id(item.cid)
            .onPreDrag((status: PreDragStatus) => {
              this.PreDragChange(status);
            })
            .onDragStart((event: DragEvent, extraParams: string) => { // TODO：知识点：在ListItem层，通过onDragStart实现拖拽开始时的回调行为
              // item.visible = false; // 拖拽时，设置子组件原位置图标不可见
              item.alp = 0.5
              item.showBorder = true
              // 记录目标位置子组件index值
              this.dragIndex = (JSON.parse(extraParams) as JsonObjType).selectedIndex;
              this.dragItem = item
              let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById(item.cid);
              this.dragComponentInfo = modePosition
              // hsLog.d(TAG,`===onDragStart: devet:${JSON.stringify(event)}  params:${extraParams}`)
              // hsLog.d(TAG,`===onDragStart----info:${JSON.stringify(modePosition)}`)

              let y = event.getDisplayY()
              hsLog.d(TAG,`====onDragStart: Y= ${y}`)

              return {
                builder: this.pixelCellBuilder(item)
              }
              // 若需要拖拽显示builder，需要移除掉pixelMap属性的赋值。
              // pixelMap:this.pixelMap,
              // 若设置了builder并且不需要传递extraInfo，需要移除掉extraInfo属性的赋值。
              // extraInfo: "test"
              // return this.pixelCellBuilder(item)
            })
            .onDragLeave((event: DragEvent, extraParams: string) => {
              // 拖拽离开组件范围内时，触发回调，当监听了onDrop事件时，此事件才有效。
              hsLog.d(TAG,`===onDragLeave: devet:${JSON.stringify(event)}  params:${extraParams}`)
              let y = event.getDisplayY()
              hsLog.d(TAG,`====onDragLeave: Y= ${y}`)

            })
            .onDragEnter((event: DragEvent, extraParams: string) => {
              //拖拽进入组件范围内时，触发回调，当监听了onDrop事件时，此事件才有效。
              hsLog.d(TAG,`===onDragEnter: devet:${JSON.stringify(event)}  params:${extraParams}`)

              let y = event.getDisplayY()
              hsLog.d(TAG,`====onDragEnter: Y= ${y}`)

              // onDragEnd里取到的result值在接收方onDrop设置

            })
            .onDragMove((event: DragEvent, extraParams: string) => {
              hsLog.d(TAG,`===onDragMove: devet:${JSON.stringify(event)}  params:${extraParams}`)

              let y = event.getDisplayY()
              hsLog.d(TAG,`====onDragMove: Y= ${y}`)

            })
            .onDragEnd((event: DragEvent, extraParams: string) => {
              //// onDragEnd里取到的result值在接收方onDrop设置

              let y = event.getDisplayY()
              hsLog.d(TAG,`====onDragEnd: Y= ${y}`)

              hsLog.d(TAG,`===onDragStart: devet:${item.name} `)
              hsLog.d(TAG,`===onDragEnd: devet:${JSON.stringify(event)}  params:${extraParams}`)

              item.visible = true;
              item.alp = 1
              item.showBorder = false

              if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                hsLog.d(TAG,`===onDragEnd 获取onDrop返回的状态值: success `)

              }

              })
            // .onDrop((event: DragEvent, extraParams: string) => {
            // //   //注意，这个设置了，外层list上设置的就没有效果了
            //   let y = event.getDisplayY()
            //   hsLog.d(TAG,`====onDrop: Y= ${y}`)
            //   hsLog.d(TAG,`===onDrop: devet:${JSON.stringify(event)}  params:${extraParams}`)
            // //   //绑定此事件的组件可作为释放目标。当在本组件范围内停止拖放行为时，将触发回调。
            // //   // 如果开发者未在onDrop中主动调用event.setResult()来设置拖拽接收的结果，
            // //   // 对于系统支持的默认可拖入组件，处理结果将依据系统实际处理的数据。对于其他组件，系统将默认视为数据接收成功。
            // //
            // //
            // //   // 在这里取不到index
            // //   // let insertIndex: number = (JSON.parse(extraParams) as JsonObjType).insertIndex; // 通过参数extraParams获取原位置子组件index值
            // //   // if (insertIndex >= this.dataSource.totalCount()) {
            // //   //   return;
            // //   // }
            // //   // this.changeIndex(this.dragIndex, insertIndex); // 互换子组件index值
            // //   // this.dataSource.notifyDataReload();
            // //
            // //   // 显式设置result为successful，则将该值传递给拖出方的onDragEnd
            // //   event.setResult(DragResult.DRAG_SUCCESSFUL);
            // })
            // .dragPreview((value: CustomBuilder | DragItemInfo | string)=>{
            //   // 配置自定义拖拽过程中的预览图样式。
            //   // onlyForLifting true 优先使用开发者在onDragStart中返回的背板图，如果onDragStart中没有返回背板图则使用组件自截图。
            // })
          }, (item: AppInfo) => item.name.toString())
        }
        .scrollBar(BarState.Off)
        .constraintSize({minHeight:'100vp', maxHeight:'200vp'})
        .listDirection(Axis.Vertical)
        .alignListItem(ListItemAlign.Center)
        .onDragStart((event: DragEvent, extraParams: string) => {
          hsLog.d(TAG,`===list onDragStart: devet:${JSON.stringify(event)}  params:${extraParams}`)

          let y = event.getDisplayY()
          hsLog.d(TAG,`====list onDragStart: Y= ${y}`)
        })
        .onDragEnter((event: DragEvent, extraParams: string) => {
          hsLog.d(TAG,`===list onDragEnter: devet:${JSON.stringify(event)}  params:${extraParams}`)
          let y = event.getDisplayY()
          hsLog.d(TAG,`====list onDragEnter: Y= ${y}`)
        })
        .onDragMove((event: DragEvent, extraParams: string) => {
          let eventData = event.getData()
          let y = event.getDisplayY()
          hsLog.d(TAG,`====list onDragMove: Y= ${y}`)

          hsLog.d(TAG,`===list onDragMove: devet:${JSON.stringify(event)}  params:${extraParams} eventData:${JSON.stringify(eventData)}`)
          // this.getAllComponentInfo()

        })
        .onDragEnd((event: DragEvent, extraParams: string) => {
          let y = event.getDisplayY()
          hsLog.d(TAG,`====list onDragEnd: Y= ${y}`)

          hsLog.d(TAG,`===list onDragEnd: devet:${JSON.stringify(event)}  params:${extraParams}`)
        })
        .onDrop((event: DragEvent, extraParams: string) => { // TODO：知识点：在List层，通过onDrop实现拖拽结束后的回调行为

          hsLog.d(TAG,`===list onDrop: devet:${JSON.stringify(event)}  params:${extraParams}`)

          let y = event.getDisplayY()
          hsLog.d(TAG,`====list onDrop: Y= ${y}`)
          this.getDataFromUdmf((event as DragEvent), (event: DragEvent) => {
            let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
            let rect: Rectangle = event.getPreviewRect();

            hsLog.d(TAG,`===list onDrop event: ${JSON.stringify(rect)}}`)


            event.useCustomDropAnimation = false;
            // 显式设置result为successful，则将该值传递给拖出方的onDragEnd
            event.setResult(DragResult.DRAG_SUCCESSFUL);
          })

          let insertIndex: number = (JSON.parse(extraParams) as JsonObjType).insertIndex; // 通过参数extraParams获取原位置子组件index值
          if (insertIndex >= this.dataSource.totalCount()) {
            return;
          }
          this.changeIndex(this.dragIndex, insertIndex); // 互换子组件index值
          this.dataSource.notifyDataReload();
        })
        // .enableScrollInteraction(false) // 禁用滑动
        .alignListItem(ListItemAlign.Center)
        .padding({
          // top: $r("app.string.drag_and_exchange_layout_10"),
          // bottom: $r("app.string.drag_and_exchange_layout_10"),
          left: $r("app.string.drag_and_exchange_layout_15"),
          right: $r("app.string.drag_and_exchange_layout_15")
        })
      }
      .justifyContent(FlexAlign.Center)
      .width($r("app.string.drag_and_exchange_layout_90_percent"))
      .borderRadius($r("app.string.drag_and_exchange_layout_20"))
      .opacity($r("app.string.drag_and_exchange_background_opacity"))
      .backgroundColor($r('app.color.drag_and_exchange_background_color'))
    }
    // .margin({ top: $r("app.string.drag_and_exchange_layout_20") })
  }

  getAllComponentInfo() {
    hsLog.d(TAG,`>>>>>> start`)

    let testPosition: componentUtils.ComponentInfo = componentUtils.getRectangleById('cid_test');
    hsLog.d(TAG,`-----testPosition: ---- ${JSON.stringify(testPosition)}`)

    // let currentPosition: componentUtils.ComponentInfo = componentUtils.getRectangleById(this.dragItem?.cid);
    // hsLog.d(TAG,`-----current:${this.dragItem?.name} ---- ${JSON.stringify(currentPosition)}`)

    for (let i=0; i < this.dataSource.totalCount()-1; i++) {
      let tempModel = this.dataSource.getData(i)
      let tempPosition: componentUtils.ComponentInfo = componentUtils.getRectangleById(tempModel.cid);
      hsLog.d(TAG,`-----temp:${tempModel.name} ---- ${JSON.stringify(tempPosition)}`)

    }
    hsLog.d(TAG,`>>>>>>  end`)

  }
  updateIsIn() {

  }

  @Builder
  pixelCellBuilder(app: AppInfo) {
    Column() {
      Image(app.icon)
        .id(`${app.name}`)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .height($r("app.string.drag_and_exchange_icon_square_size"))
        .objectFit(ImageFit.Cover)
        .borderRadius($r("app.string.drag_and_exchange_layout_10"))
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响List子组件拖拽动效，所以修改为false
      Text(app.name)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: $r("app.string.drag_and_exchange_layout_1") })
        .fontSize($r("app.string.drag_and_exchange_app_name_font_size"))
    }
    .justifyContent(FlexAlign.Start)
    // .width('100%')
    .width('300vp')
    .id("cid_test")
    // .borderWidth(app.showBorder ? 3 : 0)
    // .borderColor(app.showBorder ? Color.Blue : '')
    .opacity(app.alp)
    // .visibility(app.visible ? Visibility.Visible : Visibility.Hidden)
    .backgroundColor(YWConstants.RandomColor())
    .onAreaChange((oldValue: Area, newValue: Area) => {
      hsLog.d(TAG,`<<<<Ace: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
    })
  }

  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      hsLog.i(TAG,"udmfRetry getData failed, code = " + (e as BusinessError).code + ", message = " + (e as BusinessError).message);
      return false;
    }
  }

  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }

  private PreDragChange(preDragStatus: PreDragStatus): void {
    if (preDragStatus == PreDragStatus.READY_TO_TRIGGER_DRAG_ACTION) {
      this.backGroundColor = Color.Red;
    } else if (preDragStatus == PreDragStatus.ACTION_CANCELED_BEFORE_DRAG
      || preDragStatus == PreDragStatus.PREVIEW_LANDING_FINISHED) {
      this.backGroundColor = Color.Blue;
    }
  }
}

/**
 * 无名字App自定义组件
 */
@Component
struct IconNoNameView {
  @ObjectLink app: AppInfo;

  build() {
    Row() {
      Image(this.app.icon)
        .id(`${this.app.name}`)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .height($r("app.string.drag_and_exchange_icon_square_size"))
        .objectFit(ImageFit.Cover)
        .borderRadius($r("app.string.drag_and_exchange_layout_10"))
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响List子组件拖拽动效，所以修改为false
      Text(this.app.name)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: $r("app.string.drag_and_exchange_layout_1") })
        .fontSize($r("app.string.drag_and_exchange_app_name_font_size"))
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    // .borderWidth(this.app.showBorder ? 5 : 0)
    // .borderColor(this.app.showBorder ? Color.Blue : '')
    .opacity(this.app.alp)
    .visibility(this.app.visible ? Visibility.Visible :
    Visibility.Hidden) // 消失时需要占位，所以使用显隐控制而非条件渲染。（条件渲染与显隐控制区别，参考资料：https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/proper-choice-between-if-and-visibility.md/）
  }
}

/**
 * 封装处理处理JSON对象的类
 */
class JsonObjType {
  public insertIndex: number;
  public selectedIndex: number;

  constructor(insertIndex: number, selectedIndex: number) {
    this.insertIndex = insertIndex;
    this.selectedIndex = selectedIndex;
  }
}