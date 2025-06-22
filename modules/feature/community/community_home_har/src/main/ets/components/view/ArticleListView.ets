import { YWConstants } from "@learn/constants_har";
import { CommunityArticleInfo } from "../model/CommunityModel"
import { CommunityUIState } from "../viewmodel/CommunityViewModel"
import { TopBannerView } from "./TopBannerView";

@ComponentV2
export struct ArticleListView {

  @Param @Require uiState:CommunityUIState

  @Local selectedId: number = -1; // 刚加载完成无选中状态

  @Local bottomHeight: number = 0; // 底部导航栏高度

  @Builder
  topHeader() {
    Column(){
      TopBannerView({uiState: this.uiState})
    }
    .width('100%')
    .aspectRatio(1.3333)
    .backgroundColor(YWConstants.RandomColor())
  }

  build() {
    List({ space: 10, scroller: this.uiState.scroller }) {
      ListItemGroup({header: this.topHeader()})
      LazyForEach(this.uiState.articleDatas, (item: CommunityArticleInfo) => {
        ListItem() {
          ItemView({ item: item, isSelected: this.selectedId === item.id });
        }
        .onClick(() => {

        })
      }, (item: CommunityArticleInfo) => item.id.toString())
    }
    // 隐藏滚动条
    .scrollBar(BarState.Off)
    .cachedCount(3)
    .backgroundColor('#FFF1F3F5')
    .padding({
      left: 12,
      right: 12,
      bottom: this.bottomHeight + 'px'
    })
    .width('100%')
    .height('100%')
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
  }
}

@ComponentV2
export struct ItemView {
  @Param @Require item: CommunityArticleInfo;
  @Param isSelected: boolean = false;

  @Builder
  viewsBuilder() {
    Row() {
      Image($r("app.media.status_bar_animation_eye_open"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width(18)
        .aspectRatio(1)
        .margin({
          right: 4
        })
      Text(`${this.item.views}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(13)
        .opacity(0.6)
    }
  }

  @Builder
  likesBuilder() {
    Row() {
      Image(this.item.isLike ? $r("app.media.status_bar_animation_good_on") :
      $r("app.media.status_bar_animation_good_off"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width(18)
        .aspectRatio(1)
        .margin({
          right: 4
        })
      Text(`${this.item.likes}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(13)
        .opacity(0.6)
    }
  }

  @Builder
  collectBuilder() {
    Row() {
      Image(this.item.isCollection ? $r("app.media.status_bar_animation_collect_on") :
      $r("app.media.status_bar_animation_collect_off"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width(18)
        .aspectRatio(1)
        .margin({
          right: 4
        })
      Text(`${this.item.collections}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(13)
        .opacity(0.6)
    }
  }

  @Builder
  typeBuilder() {
    Text("摄影作品")
      .fontSize(10)
      .fontColor("#FF3E50")
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .borderRadius(4)
      .backgroundColor('#1AFF3E50')
      .padding({
        left: 8,
        right: 8,
        top: 2,
        bottom: 2
      })
  }

  @Builder
  tagBuilder() {
    Text('自然风光')
      .fontSize(10)
      .fontColor('#0A59F7')
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .borderRadius(4)
      .backgroundColor('#1A0A59F7')
      .padding({
        left: 8,
        right: 8,
        top: 2,
        bottom: 2
      })
  }

  build() {
    // TODO: 知识点：相对布局组件，用于复杂场景中元素对齐的布局，容器内子组件区分水平方向，垂直方向子组件可以将容器或者其他子组件设为锚点。
    RelativeContainer() {
      Row() {
        Column() {
          // 标题
          Text(this.item.title)
            .fontSize(14)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .opacity(0.9)
            .width('100%')
            .maxLines(1)
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              left: { anchor: "__container__", align: HorizontalAlign.Start }
            })
            .id("title")
          // 内容
          Text(this.item.content)
            .fontSize(12)
            .opacity(0.6)
            .maxLines(2)
            .width('100%')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .alignRules({
              left: { anchor: "title", align: HorizontalAlign.Start },
              top: { anchor: "title", align: VerticalAlign.Bottom }
            })
            .margin({
              top: 4
            })
            .id("content")


          if (this.item.type === 2) {
            Row() {
              // 浏览量
              this.viewsBuilder();
              // 点赞数
              this.likesBuilder();
              // 收藏量
              this.collectBuilder();
            }
            .width('100%')
            .height(40)
            .alignRules({
              left: { anchor: "content", align: HorizontalAlign.Start },
              top: { anchor: "content", align: VerticalAlign.Bottom }
            })
            .justifyContent(FlexAlign.SpaceBetween)
          } else {
            Row({ space: 12 }) {
              // 摄影作品标签
              this.typeBuilder();
              // 自然风光标签
              this.tagBuilder();
            }
            .width('100%')
            .height(40)
            .padding({
              left: 8,
              right: 8
            })
            .alignRules({
              left: { anchor: "content", align: HorizontalAlign.Start },
              top: { anchor: "content", align: VerticalAlign.Bottom }
            })
            .justifyContent(FlexAlign.Start)
          }
        }
        .padding(12)
        .height('100%')
        .layoutWeight(1)

        // 图片
        Image(this.item.uri)
          .height(80)
          .backgroundColor('#FFECECEC')
          .aspectRatio(1.6)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .margin({
            right: 12
          })
          .id("image")
      }
    }
    .backgroundColor(Color.White)
    .borderRadius(8)
    .width('100%')
    .height(102)
    // item选中时的背景渐变色
    .linearGradient(this.isSelected ? {
      angle: 90,
      colors: [['#FFDCEAF9', 0],
        ['#FFF1F3F5', 1]]
    } : { colors: [] })
  }
}