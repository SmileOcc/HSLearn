import { CommonConstants } from "./common/CommonConstants";
import { AppStorageV2, promptAction } from "@kit.ArkUI";
import { webview } from "@kit.ArkWeb";
import { YWValueWrapperV2 } from "@learn/common_har";
import { YWConstants } from "@learn/constants_har";
import { NewsCommentData, NewsCommentModel } from "./model/NewsCommentData";
import { CommentInputDialog } from "./CommentInputDialog";
import { WebListCommentView } from "./WebListCommentView";
import { BusinessError } from "@kit.BasicServicesKit";
import { CommentPage } from "./CommentPage";
import { hsLog } from "@learn/logger_har";
import { util } from "@kit.ArkTS";


@Builder
export function scrollWebListCommentBuilder() {
  NavDestination(){
    ScrollWebListCommentPage()
  }
  .hideTitleBar(true)
}

const SEARCH_BUTTON: string = '搜索'; // 搜索按钮文字

// 模拟评论数据
export function mockData(): NewsCommentData {
  const commentList: NewsCommentData = new NewsCommentData();
  commentList.pushData(new NewsCommentModel("1", $r("app.media.news_image_1"), '你若安好便是晴天', '', '', '国足加油！国足必胜！', new Date('2024-11-01 23:00:00'),new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("2", $r("app.media.news_image_2"), '天要下雨娘要嫁人', '', '', '来点信心，加油加油~', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("3", $r("app.media.news_image_3"), '太阳打北边出来了', '', '', '下一场什么时候，有直播吗', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("4", $r("app.media.news_image_4"), '西红柿炒鸡蛋蛋卷(特辣)', '', '', '教练组的战术调整值得肯定，尤其是在中场控制方面有所改善。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("5", $r("app.media.news_image_6"), '东边有个塔玛，西边有个喇嘛', '', '', '期待他们在未来的比赛中继续进步！', new Date('2024-11-01 23:00:00'),new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("7", $r("app.media.news_image_7"), '天青色等烟雨而我在等你', '', '', '希望他们能在接下来的比赛中继续发挥，成为球队的中坚力量。',new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("8", $r("app.media.news_image_8"), '大事不妙了', '', '', '与世界强队的差距依然显著，继续努力吧。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("9", $r("app.media.news_image_6"), '小猫带耳机', '', '', '国足必胜，加油加油。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  return commentList;
}

const TAG = "ScrollWebListCommentPage"

@ComponentV2
export struct ScrollWebListCommentPage {
  webviewController: webview.WebviewController = new webview.WebviewController(); // 初始化WebviewController
  @Local changeValue: string = ''; // 搜索框关键词
  private listScroller: Scroller = new Scroller(); // 初始化listScroller
  @Local commentList: NewsCommentData = new NewsCommentData(); // 评论列表
  @Local curUser: string = "curUser";   // 当前用户
  @Local replyUser: string = "";   // 被回复人昵称
  @Local replyId: string = "";   // 被回复人id
  @Local textInComment: string = "";   // 评论中的文字
  // @LocalStorageLink('currentBreakPoint') currentBreakPoint: string = 'sm';

  @Local currentBreakPoint: YWValueWrapperV2<string> = AppStorageV2.connect<YWValueWrapperV2<string>>(YWValueWrapperV2,YWConstants.kCurrentBreakpoint ,()=> new YWValueWrapperV2("sm"))!
  // @Local prop: Sample = AppStorageV2.connect(Sample, () => new Sample())!;

  private scrollTop: number = 0; // Web组件滚动偏移量
  @Local isLargeDevice: boolean = false;
  private controllerSearch: SearchController = new SearchController(); // 初始化SearchController
  @Local webHeight: number = 0; // Web组件高度
  @Local isWebAtEnd: boolean = false; // web组件是否滚动到底部，ture到Web底部，false还未到底部。
  @Local commentState: boolean = false;
  @Local avoidAreaTopToModule: YWValueWrapperV2<number> = AppStorageV2.connect<YWValueWrapperV2<number>>(YWValueWrapperV2,YWConstants.kStatusBarHeight, ()=> new YWValueWrapperV2(0))!

  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: this.textInComment,
      commentState: this.commentState,
      placeholder: '@' + this.replyUser, // 回复样式为：@回复人昵称
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: {
      dx: 0,
      dy: -20
    }
  });

  /**
   * 发布评论
   */
  publishComment(): void {
    // 生成评论id
    const uuid: string = util.generateRandomUUID();
    // 添加一条评论，包含评论id、头像、昵称、回复id、回复昵称、回复文本
    const comment: NewsCommentModel =
      new NewsCommentModel(uuid, $r('app.media.news_user_select'), this.curUser, this.replyId, this.replyUser,
        this.textInComment, new Date(), new NewsCommentData());
    // 通过回复id获取该评论的父评论
    const parentComment = this.commentList.getParentData(this.replyId);
    // 如果获取到了父评论，则将该评论加到父评论下
    if (parentComment) {
      parentComment.replyList.addDataFirst(comment);
    } else {
      // 否则自己作为父评论
      this.commentList.addDataFirst(comment);
    }
    // 评论完成将回复人信息置空
    this.replyId = "";
    this.replyUser = "";
    // 滑动置顶
    this.listScroller.scrollToIndex(0, true, ScrollAlign.START);
  }

  /**
   * MyScroller组件滑动Web
   */
  scrollWeb(offset:number) {
    this.webviewController.scrollBy(0, offset);
  }
  /**
   * MyScroller组件滑动List
   */
  scrollList(offset:number){
    this.listScroller.scrollBy(0, offset);
  }

  /**
   * MyScroller获取List组件的yOffset
   */
  getListOffset():number{
    return this.listScroller.currentOffset().yOffset;
  }

  /**
   * 获取Web组件高度
   */
  getWebHeight() {
    try {
      this.webviewController?.runJavaScriptExt('window.innerHeight', (error, result) => {
        if (error || !result) {
          return;
        }
        if (result.getType() === webview.JsMessageType.NUMBER) {
          this.webHeight = result.getNumber();  // 获取Web组件高度
        }
      })
    } catch (error) {
      hsLog.e(TAG,'error' + error);
    }
  }

  /**
   * 检测web组件是否滚动到边界
   * isWebAtEnd：true  滚动到Web底部
   * isWebAtEnd：false 还未滚动到Web底部
   */
  getWebScrollEnd() { // 检测web组件是否滚动到边界，isWebAtEnd的值为ture：滚动到Web底部，false还未到底部。
    try {
      this.webviewController.runJavaScriptExt('document.documentElement.scrollTop || document.body.scrollTop',
        // 获取web组件滚动偏移量
        (error, result) => {
          if (error || !result) {
            return;
          }
          let type = result.getType();
          if (type === webview.JsMessageType.NUMBER) {
            this.scrollTop = result.getNumber();
            let pageHeight = this.webviewController.getPageHeight(); // 获取web组件内容高度
            this.isWebAtEnd = false;
            console.log('pageHeight' + pageHeight);
            if (this.scrollTop + this.webHeight >= pageHeight) { // 当web组件滚动偏移量 + web组件高度 ≥ web组件内容高度（web组件高度固定，内容可以很长）
              this.isWebAtEnd = true;
            }
          }
        });
    } catch (error) {
      hsLog.e(TAG,'error' + error);
    }
  }

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.container_nested_only_show_for_ux')
    })
  }

  aboutToAppear() {
    // 添加模拟数据
    this.commentList = mockData();
    // TODO: 高性能知识点: 提前初始化WebView内核
    webview.WebviewController.initializeWebEngine();
  }

  aboutToDisappear() {
    // 将dialogController置空
    this.dialogController = null;
  }

  // 新闻内容
  @Builder webBuilder() {
    Web({ src: $rawfile("news.html"), controller: this.webviewController })
      .javaScriptAccess(true)
        // Web网页加载完成时，禁用Web手势生成的滚动。
      .onPageEnd(e => {
        // TODO：知识点：设置禁用Web手势生成的滚动
        this.webviewController.setScrollable(false, webview.ScrollType.EVENT);
        // 获取Web组件高度
        this.getWebHeight();
      })// 禁用Web的pan手势，即鼠标滚轮和触摸板的双指滑动。
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        others: Array<GestureRecognizer>) => {
        if (current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
          // TODO：知识点：使用onGestureRecognizerJudgeBegin方法，禁用web自带的pan手势触发即鼠标滚轮和触摸板的双指滑动操作。
          return GestureJudgeResult.REJECT; // 禁用Web的鼠标滚轮和触摸板的双指滑动操作
        }
        return GestureJudgeResult.CONTINUE;
      })
      .onAppear(() => {
        try {
          // TODO：知识点：预加载图片资源，加快页面加载速度。
          this.webviewController.prefetchPage('https://bpic.588ku.com/back_origin_min_pic/21/04/07/23c8806be022255931d5dcb04c762f37.jpg');
        } catch (error) {
          console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
        }
      })
      .verticalScrollBarAccess(false) // 关闭Web的纵向滚动条
      .onClick(() => {
        this.showToast();
      })
  }

  // 评论区内容
  @Builder listBuilder() {
    List({ scroller: this.listScroller }) {
      LazyForEach(this.commentList, (item: NewsCommentModel) => {
        ListItem() {
          CommentPage({
            commonData: item,
            replyId: this.replyId,
            replyUser: this.replyUser,
            curUser: this.curUser,
            // dialogController: this.dialogController,
            dialogController: undefined,

            commentState: this.commentState,
          })
        }
      }, (item: NewsCommentModel) => item.id.toString())
    }
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.Off)
    .maintainVisibleContentPosition(false) // false: 显示区域上方插入或删除数据时可见内容位置会跟随变化。
    .enableScrollInteraction(false) // TODO：知识点：禁用List组件的手势
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.container_nested_note_nested_list_bgc_color'))
    .id('commentList')
  }

  build() {
    RelativeContainer() {
      // 标题栏
      this.title()
      /**
       * 向MyScroller组件里传入子组件Web（新闻内容）、list（评论内容）等
       *
       * @param webBuilder：web组件（新闻内容）
       * @param listBuilder：List（评论内容）
       * @param titleBuilder：评论总数标题
       * @param isWebAtEnd：传递Web组件是否滚动到下边界
       * @param getWebScrollEnd：刷新web组件偏移量
       * @param scrollWeb：刷新web组件偏移量
       * @param scrollList：MyScroller组件滑动List
       * @param getListOffset：MyScroller刷新List组件的yOffset
       */
      WebListCommentView({
        webBuilder: ()=>{ this.webBuilder() }, // Web组件（新闻内容）
        listBuilder: ()=>{ this.listBuilder() }, // List（评论内容）
        titleBuilder: ()=>{ this.CommentTitle() }, // 评论总数标题
        isWebAtEnd: this.isWebAtEnd, // 传递Web组件是否滚动到下边界
        getWebScrollEnd: ()=>{ this.getWebScrollEnd() }, // 刷新web组件偏移量
        scrollWeb:(offset:number)=>{ this.scrollWeb(offset) }, // MyScroller组件滑动Web
        scrollList: (offset:number)=>{ this.scrollList(offset) }, // MyScroller组件滑动List
        getListOffset: ():number=>{ return this.getListOffset() },// MyScroller刷新List组件的yOffset
      })
      Column() {
        Text($r('app.string.container_nested_publish_comment'))
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.TEXT3_HEIGHT)
          .borderRadius(CommonConstants.BORDER_RADIUS_TWO)
          .backgroundColor(Color.White)
          .border({
            width: $r('app.integer.container_nested_text_input_hint_border_width'),
            color: $r('app.color.container_nested_color_comment_text_border')
          })
          .padding({ left: CommonConstants.PADDING_FIFTEEN })
          .onClick(() => {
            if (this.dialogController !== null) {
              this.textInComment = "";
              this.replyId = "";
              this.replyUser = "";
              // 打开评论输入弹窗
              this.dialogController.open();
            }
          })
          .id('publishComment')
        PublishView();
      }
      .id('relative_publish')
      .width(CommonConstants.FULL_PERCENT)
      .padding({ left: CommonConstants.PADDING_LEFT_THREE, right: CommonConstants.PADDING_TEN, top: CommonConstants.PADDING_TEN })
      .height(CommonConstants.COLUMN_HEIGHT)
      .alignRules({
        bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      })
    }
    // .padding({ top: this.avoidAreaTopToModule.value })
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }

  // 标题行
  @Builder
  title(){
    Row() {
      Image($r('app.media.news_batman'))
        .height(CommonConstants.ICON_WIDTH)
        .width(CommonConstants.ICON_HEIGHT)
        .borderRadius(CommonConstants.BORDER_RADIUS_TWO)
        .id('pic')
        .autoResize(true)
        .onClick(()=>{
          this.showToast();
        })
      Row() {
        Text($r('app.string.container_nested_follow'))
          .fontColor($r('app.color.container_nested_note_follow_font_color'))
          .fontSize(CommonConstants.FOLLOW_FONTSIZE)
          .borderRadius(CommonConstants.BORDER_RADIUS_THREE)
          .height(CommonConstants.ICON1_HEIGHT)
          .width(CommonConstants.ICON2_WIDTH)
          .backgroundColor($r('app.color.container_nested_note_nested_follow_bgc_color'))
          .textAlign(TextAlign.Center)
          .alignRules({
            top: { anchor: 'pic', align: VerticalAlign.Bottom },
            left: { anchor: 'pic', align: HorizontalAlign.Start }
          })
          .id('follow')
          .onClick(() => {
            this.showToast();
          })
      }
      .margin({ left: CommonConstants.MARGIN_NEGATIVE_FOUR_TY, bottom:CommonConstants.MARGIN_NEGATIVE_THIRTY })
      .alignRules({
        top: { anchor: 'pic', align: VerticalAlign.Bottom },
        left: { anchor: 'pic', align: HorizontalAlign.Start }
      })
      .id('follow')

      Search({
        value: this.changeValue,
        placeholder: $r('app.string.container_nested_search_value'),
        controller: this.controllerSearch
      })
        .enableKeyboardOnFocus(false)
        .searchButton(SEARCH_BUTTON)
        .width($r('app.string.container_nested_search_width'))
        .margin({ left: CommonConstants.MARGIN_FIFTEEN })
        .height(CommonConstants.SEVENTY_FIVE_PERCENT)
        .backgroundColor(Color.White)
        .placeholderColor(Color.Grey)
        .placeholderFont({
          size: CommonConstants.FOUR_TEEN_FONTSIZE,
          weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
        })
        .onSubmit((value: string) => {
          this.showToast();
        })
        .onChange((value: string) => {
          this.changeValue = value;
        })
      Row() {
        Text($r('app.string.container_nested_listen'))
          .fontSize(CommonConstants.FONTSIZE_EIGHTEEN)
          .margin({ left: CommonConstants.MARGIN_FIFTEEN })

        Image($r('app.media.news_more'))
          .height(CommonConstants.THIRTY_WIDTH)
          .width(CommonConstants.THIRTY_WIDTH)
          .margin({ left: CommonConstants.MARGIN_FIFTEEN })
      }.alignRules({
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })
      .width($r('app.string.container_nested_icons_width'))
      .onClick(()=>{
        this.showToast();
      })
    }
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FIFTY)
    .padding({ left: CommonConstants.PADDING_TEN, right: CommonConstants.PADDING_TEN })
    .id("row_title")
    .alignRules({
      top: { anchor: "__container__", align: VerticalAlign.Top }
    })
  }

  // 评论标题行
  @Builder
  CommentTitle() {
    Row() {
      Text($r('app.string.container_nested_comment_text'))
        .fontSize(CommonConstants.FONTSIZE_TWENTY)
        .fontWeight(FontWeight.Bold)

      Blank()

      Text($r('app.string.container_nested_comment1_text'))
        .fontSize(CommonConstants.FOUR_TEEN_FONTSIZE)
        .fontWeight(FontWeight.Bold)
    }
    .width(CommonConstants.NINETY_FIVE_PERCENT)
    .height(CommonConstants.ROW_HEIGHT)
    .onClick(()=>{
      this.showToast();
    })
  }
}

// 页面底部分享组件
@Component
export struct PublishView {
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;

  build() {
    Row() {
      Text() {
        ImageSpan($r('app.media.news_share'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT, right: CommonConstants.MARGIN_RIGHT })
        Span($r('app.string.container_nested_share_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_comment'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_comment3_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_follow'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_star_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_star'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_collect_text'))
      }.width($r('app.string.container_nested_publish_width'))
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.SIXTY_HEIGHT)
    .onClick(()=>{
      promptAction.showToast({ message: $r('app.string.container_nested_only_show_for_ux') });
    })
  }
}