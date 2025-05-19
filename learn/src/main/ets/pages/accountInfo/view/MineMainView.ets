import { MineItem, MineViewModel } from '../model/MineViewModel'
import { MineInfoView } from './MineInfoView'
import { MineNavBarView } from './MineNavBarView'
import { router } from '@kit.ArkUI'
import { YWConstants } from '@learn/constants_har';
import { UserInfoModel } from '../model/UserInfoModel'
import { kyStoreManger, QDImageCompressionUtils, hsGlobalThis,   } from '@learn/common_har';
import { loginService } from '@learn/login_har'
import { API, netReq } from '@learn/request_har';
import { YWResImage } from '@learn/res_har'
import { YWNavBar } from '@learn/baseui_har';
import { hsLog } from '@learn/logger_har';

const TAG = 'MineMainView'
@Component
export struct MineMainView {

  @Link userInfo:UserInfoModel

  @StorageProp('statusHeight') statusHeight: number = 0; //状态栏高度（单位：vp）
  @StorageProp('isLogin') @Watch('onLonginChange') isLogin: boolean = false; //是否登录
  // @State head: PixelMap | ResourceStr = $r('app.media.app_icon');
  @State head: PixelMap | ResourceStr = YWResImage.appIcon();

  @State nickname: string = '';

  mineViewModel = new MineViewModel()

  scorllView:Scroller = new Scroller()


  onLonginChange() {
    if (this.isLogin) {
      netReq.post<Record<string, string>, Record<string, string[]>>(API.userInfos, { 'infos': ['nickname', 'avatar'] }, {
        onSuccess: (data: Record<string, string>) => {
          hsLog.i(TAG, '数据回调：' + JSON.stringify(data));
          if (data['avatar'] === undefined || data['avatar'] === '') {
            this.head = $r('app.media.app_icon');
          } else {
            this.head = data['avatar'];
          }
          if (data['nickname'] !== undefined) {
            this.nickname = data['nickname'];
          } else {
            this.nickname = '';
          }
        },
        onFail: (code: number, message: string) => {
          hsLog.i(TAG, '数据回调：' + code + ' | ' + message);
        }
      });
    } else {
      this.nickname = '';
      this.head = $r('app.media.app_icon');
    }
  }

  private openPickImgDialog() {
    // this.dialogController = new CustomDialogController({
    //   builder: PickImgDialog({
    //     onOk: async (index: number) => {
    //       if (index == 2) {
    //         return;
    //       } //取消
    //       if (index == 1) { //相机
    //         permission.request('ohos.permission.CAMERA', (agree: boolean) =>{
    //           if (!agree){
    //             HintDialog.open({
    //               content: '该功能需要您开启相机权限方可使用！',
    //               okMsg: '前往开启',
    //               onOk: () => {
    //                 IntentUtil.jumpSettingsApp(OsUtil.getBundleName())
    //               }
    //             })
    //             return;
    //           }
    //           new ImageDo({ type: doi.TypeIn.Camera })
    //             .onError(this.onImageDoError)
    //             .onProcess((process: IProcess) => {
    //               if (process.plan === Plan.Out && process.record !== undefined) { //输出的结果就是字符串
    //                 this.dealBase64Img('data:image/png;base64,' + process.record.value as string);
    //               }
    //             })
    //             .decorators([{ type: doi.TypeDecor.Compress, compressKb: 20 }])
    //             .outs([doi.TypeOut.Base64])
    //             .do();
    //         });
    //         return;
    //       }
    //       //相册
    //       new ImageDo({ type: doi.TypeIn.Album })
    //         .onError(this.onImageDoError)
    //         .onProcess((process: IProcess) => {
    //           if (process.plan === Plan.Out && process.record !== undefined) { //输出的结果就是字符串
    //             this.dealBase64Img('data:image/png;base64,' + process.record.value as string);
    //           }
    //         })
    //         .decorators([{ type: doi.TypeDecor.Compress, compressKb: 20 }])
    //         .outs([doi.TypeOut.Base64])
    //         .do();
    //     }
    //   }),
    //   cornerRadius: 0,
    //   alignment: DialogAlignment.Bottom,
    //   customStyle: true,
    // })
    // this.dialogController.open()
  }

  private dealBase64Img(img: string) {
    //更新头像
    // Loading.open();
    // net.post<Record<string, string>, Record<string, string>>(API.updateAvatar, { 'img': img, }, {
    //   onSuccess: (data: Record<string, string>) => {
    //     log.i(TAG, '数据回调：' + JSON.stringify(data));
    //     this.head = img;
    //     kvManger.put(Const.BASE64_HEAD, img);
    //   },
    //   onFail: (code: number, message: string) => {
    //     log.i(TAG, '数据回调：' + code + ' | ' + message);
    //     HintDialog.open({
    //       content: message,
    //       showNo: false
    //     })
    //   },
    //   onFinally: () => {
    //     Loading.close();
    //   }
    // });
  }

  @Builder menuGroupItemView(items:MineItem[]) {

    ForEach(items,(subItem:MineItem,subIndex) => {
      ListItem() {
        Column(){
          Row(){
            Row(){
              Image($r('app.media.tab_new_select'))
                .objectFit(ImageFit.ScaleDown)
                .size({width:24,height:24})
              Text(subItem.title)
                .fontSize(14)
                .fontColor(Color.Black)
                .margin({left:12})
            }
            Image($r('app.media.arrow_right_new'))
              .objectFit(ImageFit.ScaleDown)
              .size({width:24,height:16})

          }
          .height(56)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          if (subIndex != items.length - 1) {
            Line()
              .height(0.5)
              .backgroundColor(YWConstants.COLOR_EEEEEE)
              .width('100%')
          }
        }
      }
      .backgroundColor(Color.White)
      .padding({left:12,right:12})
      .onClick(()=> {
        router.pushUrl({url:'pages/mine/ctrl/MyOrderPage'})
      })
    })

  }

  // editUserEvent: (() => void) = ()=>{
  //
  // }
  editUserEvent(){
    // router.pushUrl({url:'pages/accountInfo/ctrl/MineInfoPage'})

    // YWGlobalThis.getInstance().blockQuickClick(() => {
      if (this.isLogin) {
        this.openPickImgDialog()
      } else {
        loginService.login()
      }
    // })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {

      Scroll(this.scorllView){
        Column(){
          Column(){
            MineNavBarView({userInfo:this.userInfo,editBlock:this.editUserEvent})

            MineInfoView({userInfo:this.userInfo})
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          List({space:12}){
            ForEach(this.mineViewModel.groups, (items:Array<MineItem>,index) => {
              ListItemGroup(){
                this.menuGroupItemView(items)
              }
              .borderRadius(16)
              .clip(true)

            },(item:string):string => item)
          }
          .padding({left:13,right:13,top:12,bottom:12})
          // .divider({
          //   strokeWidth: 1,
          //   startMargin: 0,
          //   endMargin: 0,
          //   color: '#ffe9f0f0'
          // })
        }
      }
      .backgroundColor(YWConstants.COLOR_PAGE_BGC)
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}

enum MineItemRadiusType {
  top,
  bottom,
  no
}

//自定义样式
@Extend(ListItem) function oprateListItemStyle(radiusType:MineItemRadiusType){
  .borderRadius(radiusType == MineItemRadiusType.top ? {topLeft:16,topRight:16} : (radiusType == MineItemRadiusType.bottom ? {bottomLeft:16,bottomRight:16} : 0))
  .clip(true)

}

@Extend(Text) function  fristText() {
  .backgroundColor(Color.Red)
  .secondText()
}

@Extend(Text) function  secondText() {
  .backgroundColor(Color.Red)
}

