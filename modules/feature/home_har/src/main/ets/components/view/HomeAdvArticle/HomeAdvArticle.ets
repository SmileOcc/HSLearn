import { hsLog } from "@learn/logger_har";
import { HomeAdvModel } from "../../model/HomeAdvModel";
import { ARTICLE_DATA } from "../../model/HomeMockData";
import { HomeTreeNode } from "../../model/HomeTreeNode";
import { HomeArticleSectionView } from "./HomeArticleSectionView";

@Component
export struct HomeAdvArticleList {
  @State articleNodes: HomeTreeNode[] = [];

  aboutToAppear(): void {
    this.articleNodes = this.handleData(ARTICLE_DATA);
  }

  handleData(articleData: HomeAdvModel[]) {
    let newData = articleData.map((item) => {
      let obj = new HomeTreeNode()
      obj.type = item.interType;
      obj.title = item.title ?? "";
      obj.url = item.url;
      if (item.items) {
        obj.children = this.handleData(item.items);
      }
      return obj;
    })
    return newData;
  }

  build() {
    Column() {
      /**
       * 折叠面板视图
       *
       * @param {TreeNode[]} articleNodes - 折叠面板列表数据
       * @param {(articleNode: TreeNode)=>void} articleItemBuilder - 列表项视图
       * @param {(articleNode: TreeNode, isExpand:boolean)=>void} articleHeaderBuilder - 列表头部视图
       */
      HomeArticleSectionView({
        articleNodes: this.articleNodes,
        articleItemBuilder: this.articleItemBuilder,
        articleHeaderBuilder: this.articleHeaderBuilder
      })
    }
  }
  @Builder
  articleItemBuilder(articleNode: HomeTreeNode) {
    Column() {
      Row() {
        Text(articleNode.title)
          .fontSize($r('app.integer.collapse_menu_text_font_size'))
          .layoutWeight(1)
          .align(Alignment.Start)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.col_262626'))
        Blank()
      }
      .height($r('app.integer.collapse_menu_fourth_level_height'))
      .width('100%')
      .onClick(() => {
        if (articleNode.url) {
          hsLog.i(`ArticleNode` + JSON.stringify(articleNode));
          //FoldableRouter.pushUri('collapsemenu/ArticleWebComponent', articleNode);
          AppStorage.setOrCreate('articleWebUrl', articleNode.url);
        }
      })
    }
  }

  @Builder
  articleHeaderBuilder(articleNode: HomeTreeNode) {
    Row() {
      Text(articleNode.title)
        .fontSize($r('app.integer.collapse_menu_text_font_size'))
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor($r('app.color.col_262626'))

      Blank()

      Image(articleNode.expand ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
        .width(articleNode.expand  ? $r('app.integer.collapse_menu_arrow_unfold_width') :
        $r('app.integer.collapse_menu_arrow_width'))
        .height(articleNode.expand  ? $r('app.integer.collapse_menu_arrow_width') :
        $r('app.integer.collapse_menu_arrow_unfold_width'))
        .margin({ right: articleNode.expand  ? 0 : $r('app.integer.collapse_menu_arrow_fold_margin_right') })
    }
    .height(56)
    .width('100%')
  }
}