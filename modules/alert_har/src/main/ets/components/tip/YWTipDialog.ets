/*
 * @Desc:
 */
import { TipParm } from './config/TipParm';
import { TipStyle } from './config/TipStyle';
import { TopTitleParm } from './config/TopTitleParm';
import { CenterTextParm } from './config/CenterTextParm';
import { CenterWebParm } from './config/CenterWebParm';
import { BottomBtnParm } from './config/BottomBtnParm';
import { CoreDialog } from './dialog/CoreDialog';
// import { global, log, RouterUtil } from '@common/utils';
import { hsGlobalThis, YWNavRouterUtils } from '@learn/common_har'
import { curves } from '@kit.ArkUI';
import { hsLog } from '@learn/logger_har';

@Component
export struct YWTipDialog {
  private gStyle: TipStyle | undefined = hsGlobalThis.getObject<TipStyle>('TipStyle');
  private TipStyle: TipStyle = this.gStyle ? this.gStyle : {};
  @State result: string = "";
  @State backCancel: boolean = true;
  @Provide TopTitleParm: TopTitleParm | undefined = undefined;
  @Provide CenterTextParm: CenterTextParm | undefined = undefined;
  @Provide CenterWebParm: CenterWebParm | undefined = undefined;
  @Provide BottomBtnParm: BottomBtnParm | undefined = undefined;
  @State outsideCancel: boolean = true;
  @State alignment: Alignment = Alignment.Center;
  @State outBoxAttr: AttributeModifier<ColumnAttribute> | undefined = undefined;
  @State lineTop: AttributeModifier<LineAttribute> | undefined = undefined;
  @State lineBottom: AttributeModifier<LineAttribute> | undefined = undefined;

  build() {
    NavDestination() {
      Stack() {
        Stack()
          .width('100%')
          .height('100%')
          .onClick(() => {
            if (this.outsideCancel) {
              YWTipDialog.close();
            }
          })
        CoreDialog({
          outBoxAttr: this.outBoxAttr,
          lineStyleTop: this.lineTop,
          lineStyleBottom: this.lineBottom
        })
          .transition(TransitionEffect.SLIDE.combine(TransitionEffect.move(TransitionEdge.END)
            .animation({ curve: curves.springMotion() })))
      }
      .backgroundColor($r('sys.color.mask_secondary'))
      .alignContent(this.alignment)
      .width('100%')
      .height('100%')
    }
    .onReady(cxt => {
      const parm = cxt.pathInfo.param as TipParm;
      this.createParm(parm);
    })
    .onBackPressed(() => {
      return !this.backCancel;
    })
    .mode(NavDestinationMode.DIALOG)
    .hideTitleBar(true)
  }

  private createTopTitleParm(cur: TipParm, deft: TopTitleParm | undefined) {
    //不显示标题
    if (deft === undefined && cur.noTitle === true) {
      return;
    }
    const parm = new TopTitleParm();
    if (deft !== undefined) {
      parm.title = deft.title !== undefined ? deft.title : parm.title;
      parm.attrModifier = deft.attrModifier !== undefined ? deft.attrModifier : parm.attrModifier;
    }
    if (cur.title !== undefined) {
      parm.title = cur.title;
    }
    return parm;
  }

  private createCenterTextParm(cur: TipParm, deft: CenterTextParm | undefined) {
    if (deft === undefined && cur.isWebType !== undefined) {
      return;
    }
    const parm = new CenterTextParm('');
    if (deft !== undefined) {
      parm.content = deft.content !== undefined ? deft.content : parm.content;
      parm.attrModifier = deft.attrModifier !== undefined ? deft.attrModifier : parm.attrModifier;
    }
    if (cur.content !== undefined && cur.content !== '') {
      parm.content = cur.content;
    }
    return parm;
  }

  private createCenterWebParm(cur: TipParm, deft: CenterWebParm | undefined) {
    if (deft === undefined && cur.isWebType === undefined) {
      return;
    }
    const parm = new CenterWebParm('');
    if (deft !== undefined) {
      parm.url = deft.url !== undefined ? deft.url : parm.url;
      parm.attrModifier = deft.attrModifier !== undefined ? deft.attrModifier : parm.attrModifier;
    }
    if (cur.content !== undefined && cur.content !== '') {
      parm.url = cur.content;
    }
    parm.controller = cur.controller !== undefined ? cur.controller : parm.controller;
    return parm;
  }

  private createBottomBtnParm(cur: TipParm, deft: BottomBtnParm | undefined) {
    const parm = new BottomBtnParm();
    if (deft !== undefined) {
      parm.showNo = deft.showNo !== undefined ? deft.showNo : parm.showNo;
      parm.noMsg = (deft.noMsg !== undefined && deft.noMsg !== '') ? deft.noMsg : parm.noMsg;
      parm.okMsg = (deft.okMsg !== undefined && deft.okMsg !== '') ? deft.okMsg : parm.okMsg;
      parm.attrNoModifier = deft.attrNoModifier !== undefined ? deft.attrNoModifier : parm.attrNoModifier;
      parm.attrOkModifier = deft.attrOkModifier !== undefined ? deft.attrOkModifier : parm.attrOkModifier;
      parm.attrLineModifier = deft.attrLineModifier !== undefined ? deft.attrLineModifier : parm.attrLineModifier;
    }
    parm.showNo = cur.showNo !== undefined ? cur.showNo : parm.showNo;
    parm.noMsg = (cur.noMsg !== undefined && cur.noMsg !== '') ? cur.noMsg : parm.noMsg;
    parm.okMsg = (cur.okMsg !== undefined && cur.okMsg !== '') ? cur.okMsg : parm.okMsg;
    return parm;
  }

  private createParm(parm: TipParm): void {
    hsLog.i('ssss', JSON.stringify(this.TipStyle));
    //点击是否可以取消，默认true
    const outC = this.TipStyle.outsideCancel;
    this.outsideCancel = parm.outsideCancel !== undefined ? parm.outsideCancel : (outC !== undefined ? outC : true);
    const back = this.TipStyle.pressBackCancel;
    this.backCancel = parm.pressBackCancel !== undefined ? parm.pressBackCancel : (back !== undefined ? back : true);
    //位置
    const ali = this.TipStyle.alignment;
    this.alignment = parm.alignment !== undefined ? parm.alignment : (ali !== undefined ? ali : Alignment.Center);

    this.TopTitleParm = this.createTopTitleParm(parm, this.TipStyle.titleParm)
    this.CenterTextParm = this.createCenterTextParm(parm, this.TipStyle.textParm)
    this.CenterWebParm = this.createCenterWebParm(parm, this.TipStyle.webParm)
    this.BottomBtnParm = this.createBottomBtnParm(parm, this.TipStyle.btnParm)

    //最外层样式
    const outBA = this.TipStyle.outBoxAttr;
    this.outBoxAttr = outBA !== undefined ? outBA : {};
    const lineTop = this.TipStyle.lineStyleTop;
    if (this.TopTitleParm === undefined) { //不显示标题的情况下，顶部的线也没有必要存在
      this.lineTop = {
        applyNormalAttribute(instance: LineAttribute) {
          instance.visibility(Visibility.None)
        }
      }
    } else {
      this.lineTop = lineTop !== undefined ? lineTop : {};
    }
    const lineBottom = this.TipStyle.lineStyleBottom;
    this.lineBottom = lineBottom !== undefined ? lineBottom : {};

    //以下是处理按钮的点击事件
    let onNo = this.BottomBtnParm.onNo;
    let onOk = this.BottomBtnParm.onOk;
    if (parm.onNo !== undefined) {
      onNo = parm.onNo;
    }
    if (parm.onOk !== undefined) {
      onOk = parm.onOk;
    }
    const proxyOnNo = () => {
      YWTipDialog.close();
      if (!onNo) {
        return;
      }
      setTimeout(() => {
        onNo?.();
      }, 50)
    };
    this.BottomBtnParm.bOnNo(proxyOnNo)
    this.BottomBtnParm.bOnOk(() => {
      YWTipDialog.close();
      if (!onOk) {
        return;
      }
      setTimeout(() => { //为了页面跳转的动画
        onOk?.();
      }, 50)
    })
  }

  /**
   * 全局初始化样式
   */
  static initDefaultStyle(TipStyle: TipStyle) {
    hsGlobalThis.setObject('TipStyle', TipStyle);
  }

  static open(parm: TipParm) {
    //TODO 测试数据
    YWNavRouterUtils.push('YWTipDialog', parm)
  }

  public static close() {
    YWNavRouterUtils.finishPage('YWTipDialog');
  }
}

@Builder
export function RegisterBuilder(): void {
  YWTipDialog();
}