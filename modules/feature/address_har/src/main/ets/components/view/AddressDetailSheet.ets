import { HSAddressModel } from "../model/HSAddressModel";
import { LengthMetrics, LengthUnit, promptAction } from "@kit.ArkUI";
import { autoFillManager } from "@kit.AbilityKit";

export class CommonConstants {
  // toast停留时间
  static readonly TOAST_DURATION: number = 2000;
  // 动画过渡时长
  static readonly ANIMATION_DURATION = 200;
  // 分割线高度
  static readonly DIVIDER_HEIGHT: number = 2;
  // 组件间距
  static readonly SPACE_GAP_24 = 24;

  static readonly WIDTH_FULL = '100%';
  static readonly HEIGHT_FULL = '100%';


  // 商品价格及信息
  static readonly PRICE_MOUNT: string = '1款，共1件 ';
  static readonly PRICE_AMOUNT: string = '合计: ';
  static readonly PRICE_ICON: string = '¥';
  static readonly PRICE_FIRST: string = '7699';
  static readonly PRICE_LAST: string = '.00';
  static readonly REDUCE: string = '共减 ¥ 599.00';
  static readonly SUBMIT_ORDER: string = '提交订单';
  static readonly PRICE_DETAIL: string = '价格明细';
  static readonly PRICE_AMOUNT1: string = '商品总价 ';
  static readonly PRICE_AMOUNT2: string = '共1件宝贝';
  static readonly PRICE_AMOUNT3: string = '¥ 7699.00';
  static readonly PRICE_REDUCE1: string = '共减';
  static readonly PRICE_REDUCE2: string = '- ¥ 599.00';
  static readonly PRICE_ORIGIN1: string = '官方立减';
  static readonly PRICE_ORIGIN2: string = '- ¥ 499.00';
  static readonly PRICE_SHOP1: string = '店铺优惠';
  static readonly PRICE_SHOP2: string = '- ¥ 100.00';
  static readonly PRICE_ALL1: string = '合计';
  static readonly PRICE_ALL2: string = '¥ 7100.00';
  static readonly SHOP_NAME: string = 'XXX官方旗舰店';
  static readonly GOODS_NAME: string = 'XX手机PRO MAX 2025';
  static readonly TYPE_NAME: string = '512g 白色';
  static readonly PRICE_ORIGIN: string = '¥7699';
  static readonly PRICE_LOWER: string = '券后 ¥ 7100';
  static readonly GOODS_NUMBER: string = '1';

  // 收货地址信息
  static readonly NAME_BAR: string = '收货人名字';
  static readonly PHONE_BAR: string = '电话';
  static readonly ADDRESS_BAR: string = '所在地区';
  static readonly DETAIL_ADDRESS_BAR: string = '详细地址';
  static readonly USE_ADDRESS: string = '使用地址';
  static readonly ADD_ADDRESS: string = '新增地址';
  static readonly USE_SUCCESS: string = '使用成功';
  static readonly NAME_EMPTY: string = '收货人名字不能为空！';
  static readonly PHONE_EMPTY: string = '电话不能为空!';
  static readonly ADDRESS_EMPTY: string = '所在地区不能为空！';
  static readonly DETAIL_ADDRESS_EMPTY: string = '详细地址不能为空！';




  static readonly NAME: string = '李小明';
  static readonly PHONE: string = '13012345678';
  static readonly ADDRESS: string = '中国江苏省南京市雨花台区雨花街道';
  static readonly DETAIL_ADDRESS: string = '玉兰路98号';

}

@ComponentV2
export struct AddressDetailSheet {

  @Local isClicked: boolean = false;
  @Local name: string = '';
  @Local phone: string = '';
  @Local address: string = '';
  @Local detailAddress: string = '';
  @Param addressDetail?: HSAddressModel = undefined;
  // @Param showAddressDetail?: boolean = false;

  @Param dismissBlock?:()=>void = undefined

  useAddress(): void {
    if (!this.name || this.name === '') {
      promptAction.showToast({
        message: CommonConstants.NAME_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.phone || this.phone === '') {
      promptAction.showToast({
        message: CommonConstants.PHONE_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.address || this.address === '') {
      promptAction.showToast({
        message: CommonConstants.ADDRESS_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.detailAddress || this.detailAddress === '') {
      promptAction.showToast({
        message: CommonConstants.DETAIL_ADDRESS_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }

    // let newAddress: Address = new Address(this.name, this.phone, this.address, this.detailAddress);

    if (!this.isClicked) {
      // 主动触发保存历史表单输入
      autoFillManager.requestAutoSave(this.getUIContext())
      this.isClicked = true;
      // 设置超时时间以防止重复点击按钮保存历史表单输入
      setTimeout(() => {
        this.isClicked = false;
      }, 1000)
    }
    // this.addressDetail = newAddress;

    promptAction.showToast({
      message: CommonConstants.USE_SUCCESS,
      duration: CommonConstants.TOAST_DURATION,
      textColor: Color.Green
    });
    // this.showAddressDetail = false;
    this.dismissBlock?.()
  }

  build() {
    Column() {
      Column({ space: 24 }) {
        //标题行
        Row() {
          Text(CommonConstants.ADD_ADDRESS)
            .width(CommonConstants.WIDTH_FULL)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .width(CommonConstants.WIDTH_FULL)
        .height(75)
        .backgroundColor(Color.White)

        // 地址详情
        Column() {
          Column() {
            UserInfoTextInput({
              componentId: "inputName",
              text: this.name,
              contentType: ContentType.PERSON_FULL_NAME,
              label: CommonConstants.NAME_BAR,
              index: 0
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputPhone",
              text: this.phone,
              contentType: ContentType.PHONE_NUMBER,
              label: CommonConstants.PHONE_BAR,
              index: 1
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputAddress",
              text: this.address,
              contentType: ContentType.FULL_STREET_ADDRESS,
              label: CommonConstants.ADDRESS_BAR,
              index: 2
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputDetailAddress",
              text: this.detailAddress,
              contentType: ContentType.DETAIL_INFO_WITHOUT_STREET,
              label: CommonConstants.DETAIL_ADDRESS_BAR,
              index: 3
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }
        }
        .width(CommonConstants.WIDTH_FULL)
        .borderRadius(10)
        .backgroundColor(Color.White)
      }
      .height('80%')

      Blank()

      // 底部
      Column() {
        // 保存按钮
        Row() {
          Button(CommonConstants.USE_ADDRESS)
            .width(120)
            .backgroundColor(Color.Red)
            .onClick(() => {
              this.useAddress();
            })
        }
        .width(CommonConstants.WIDTH_FULL)
        .height(80)
        .backgroundColor(Color.White)
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Center)
      }
      .justifyContent(FlexAlign.End)
    }
    .padding({
      left: 24,
      right: 24
    })
    .backgroundColor(Color.White)
    .height(CommonConstants.HEIGHT_FULL)
  }
}


@ComponentV2
struct UserInfoTextInput {
  @Param componentId: string = '';
  @Param text: string = '';
  @Param contentType: ContentType | undefined = undefined;
  @Param label: ResourceStr | undefined = undefined;
  @Param index: number = -1;
  @Local scaleTimes: number = 1;
  @Local currentIndex: number = -1;
  @Local valueText: string =''

  aboutToAppear(): void {
    this.valueText = this.text
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      TextInput({ text: this.valueText })
        .id(this.componentId)
        .width(CommonConstants.WIDTH_FULL)
        .backgroundColor(Color.White)
        .contentType(this.contentType)
        .padding({ left: 12, top: 0, bottom: 0 })
        .selectionMenuHidden(true)
        .onChange((value: string) => {
          this.valueText = value;
          if (value === '') {
            this.scaleTimes = 1;
          } else {
            this.scaleTimes = 0.75;
          }
        })
        .onFocus(() => {
          this.scaleTimes = 0.75;
          this.currentIndex = this.index;
        })
        .onBlur(() => {
          if (this.valueText === '') {
            this.scaleTimes = 1;
          }
        })
      Text() {
        Span('*')
          .fontColor('#ff5000')
          .baselineOffset(new LengthMetrics(-2, LengthUnit.VP))
        Span(this.label)
          .baselineOffset(new LengthMetrics(0, LengthUnit.VP))
      }
      .scale(this.index === this.currentIndex || this.valueText !== '' ? {
        x: this.scaleTimes,
        y: this.scaleTimes,
        centerX: 0,
        centerY: -80
      } : {
        x: 1,
        y: 1,
        centerX: 0,
        centerY: -80
      })
      .animation({ duration: CommonConstants.ANIMATION_DURATION })
      .height(this.index === this.currentIndex ? 24 : undefined)
      .width(CommonConstants.WIDTH_FULL)
      //自身和子节点都响应触摸测试，不会阻塞兄弟节点的触摸测试，不会影响祖先节点的触摸测试。
      .hitTestBehavior(HitTestMode.Transparent)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .padding({ left: 12 })
    }
    .height(72)
  }
}