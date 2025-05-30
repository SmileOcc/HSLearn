import { AppInfo } from './model/AppInfo';
import { DataSource } from './model/DataSource';

const ICON_NUM_IN_GRID: number = 15; // 示例Grid中子组件数目

/**
 * 实现Grid场景，拖拽交换子组件位置: 通过editMode()打开编辑模式、通过onItemDragStart()
 * 指定拖拽时样式、通过onItemDrop()指定拖拽释放时的行为
 */
@Component
export struct GridSceneView {
  @State movedItem?: AppInfo = undefined;
  @State dataSource: DataSource = new DataSource();

  aboutToAppear() {
    for (let index = 1; index <= ICON_NUM_IN_GRID; index++) {
      this.dataSource.pushData(new AppInfo(`cid_${index}`,$r(`app.media.drag_and_exchange_ic_public_app${index}`), `App${index}`));
    }
  }

  build() {
    Column() {
      Text($r("app.string.drag_and_exchange_grid_drag_title"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .fontSize($r("app.string.drag_and_exchange_opt_title_font_size"))
      Row() {
        Grid() {
          // TODO: 性能知识点：图标一次性完全显示，且禁用滑动，无需懒加载。LazyForEach可以适用在动态添加数据的场景中，参考资料：
          //  https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
          LazyForEach(this.dataSource, (item: AppInfo) => {
            GridItem() {
              IconWithNameView({ app: item });
            }
            .width($r("app.string.drag_and_exchange_icon_square_size"))
            .height($r("app.string.drag_and_exchange_layout_70"))
          }, (item: AppInfo) => item.name.toString())
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
        .columnsGap($r("app.string.drag_and_exchange_layout_10"))
        .rowsGap($r("app.string.drag_and_exchange_layout_10"))
        .editMode(true) // TODO：知识点：设置Grid进入编辑模式，方可拖拽Grid组件内部GridItem
        .onItemDragStart((event: ItemDragInfo, itemIndex: number) => { // TODO：知识点：在Grid层，通过onItemDragStart实现拖拽开始时的回调行为
          this.movedItem = this.dataSource.getData(itemIndex);
          return this.itemWhileDrag(); //设置拖拽过程中显示的图形
        })
        .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number,
          isSuccess: boolean) => { // TODO：知识点：在Grid层，通过onItemDrop实现拖拽结束后的回调行为
          // isSuccess=false时，说明drop的位置在grid外部；insertIndex > length时，说明有新增元素的事件发生
          if (isSuccess && insertIndex < this.dataSource.totalCount()) {
            let temp: AppInfo = this.dataSource.getData(itemIndex);
            this.dataSource.setData(itemIndex, this.dataSource.getData(insertIndex));
            this.dataSource.setData(insertIndex, temp);
            this.dataSource.notifyDataReload();
          }
        })
        .padding({
          top: $r("app.string.drag_and_exchange_layout_10"),
          bottom: $r("app.string.drag_and_exchange_layout_10"),
          left: $r("app.string.drag_and_exchange_layout_5"),
          right: $r("app.string.drag_and_exchange_layout_5")
        })
      }
      .width($r("app.string.drag_and_exchange_layout_90_percent"))
      .height($r("app.string.drag_and_exchange_layout_250"))
      .borderRadius($r("app.string.drag_and_exchange_layout_20"))
      .opacity($r("app.string.drag_and_exchange_background_opacity"))
      .backgroundColor($r('app.color.drag_and_exchange_background_color'))
    }
  }

  /**
   * 设置GridItem拖拽过程中显示的图形
   */
  @Builder
  itemWhileDrag() {
    IconWithNameView({ app: this.movedItem })
      .width($r("app.string.drag_and_exchange_icon_square_size"))
      .height($r("app.string.drag_and_exchange_icon_square_size"))
  }
}

/**
 * App自定义组件
 */
@Component
struct IconWithNameView {
  @ObjectLink app: AppInfo

  build() {
    Column() {
      Image(this.app.icon)
        .id(`${this.app.name}`)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .height($r("app.string.drag_and_exchange_icon_square_size"))
        .objectFit(ImageFit.Cover)
        .borderRadius($r("app.string.drag_and_exchange_layout_10"))
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
      Text(this.app.name)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: $r("app.string.drag_and_exchange_layout_1") })
        .fontSize($r("app.string.drag_and_exchange_app_name_font_size"))
    }
  }
}
