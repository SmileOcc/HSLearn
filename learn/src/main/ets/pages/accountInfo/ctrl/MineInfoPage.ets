import { router } from '@kit.ArkUI';
import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants';
import { MineInfoItemModel, MineInfoType } from '../model/MineInfoItemModel';
import { UserInfoModel } from '../model/UserInfoModel';

@Entry
@Component
struct MineInfoPage {
  @State message: string = 'Hello World';
  @StorageLink(Constants.kStorageLocalUser) localUseInf: UserInfoModel = new UserInfoModel()
  @State groupList: Array<Array<MineInfoItemModel>> = [
    [
      {
        'infoType': MineInfoType.head,
        'title': '头像',
        'desc': '',
        'avatar': this.localUseInf.avatar ?? '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.nick,
        'title': '昵称',
        'desc': this.localUseInf.desc,
        'avatar': '',
        isArrow: true

      }
    ],
    [
      {
        'infoType': MineInfoType.name,
        'title': '姓名',
        'desc': this.localUseInf.name,
        'avatar': '',
        'isArrow': true

      },
      {
        'infoType': MineInfoType.sex,
        'title': '性别',
        'desc': this.localUseInf.sex,
        'avatar': '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.phone,
        'title': '手机号',
        'desc': this.localUseInf.tel,
        'avatar': '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.date,
        'title': '生日',
        'desc': this.localUseInf.birthday,
        'avatar': '',
        'isArrow': true
      }
    ]
  ]

  aboutToAppear(): void {

  }

  confirmAction() {

  }

  @Builder sexView(item:MineInfoItemModel) {
    Row(){

    }
  }

  @Builder menuGroupItemView(items:Array<MineInfoItemModel>) {
    ForEach(items,(subItem:MineInfoItemModel,subIndex) => {
      ListItem() {
        Column(){
          Row(){
            Row(){
              Text(subItem.title)
                .fontSize(14)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
                .margin({left:12})
            }
            if (subItem.infoType == MineInfoType.head) {
              Image(subItem.avatar)
                .size({width:40,height:40})
                .objectFit(ImageFit.ScaleDown)
                .borderWidth(0.5)
                .borderColor(Color.White)
                .borderRadius(20)
                .backgroundColor(Constants.COLOR_EEEEEE)
            } else if (subItem.infoType == MineInfoType.sex) {
              this.sexView(subItem)
            } else if (subItem.isArrow) {
              Row(){
                if (subItem.infoType == MineInfoType.date) {
                  //按钮有间隙，改text
                  Button()
                  {
                    Text(subItem.desc ?? '请选择您的生日')
                      .fontColor(subItem.desc ? Constants.COLOR_666666 : Constants.COLOR_999999)
                      .fontSize(13)
                  }
                  .buttonStyle(ButtonStyleMode.TEXTUAL)
                  .fontColor(subItem.desc ? Constants.COLOR_666666 : Constants.COLOR_999999)
                  .fontSize(13)
                  .align(Alignment.End)
                } else {
                  Button(subItem.desc??'')
                    .buttonStyle(ButtonStyleMode.TEXTUAL)
                    .fontColor(subItem.desc ? Constants.COLOR_666666 : Constants.COLOR_999999)
                    .fontSize(13)
                    .align(Alignment.End)

                }
                Image($r('app.media.arrow_right_new'))
                  .width(12)
                  .aspectRatio(1)
                  .margin({left:8})
              }
              .justifyContent(FlexAlign.End)
              .alignItems(VerticalAlign.Center)
              .onClick(()=>{

              })

            } else {
              Text(subItem.desc)
                .fontSize(13)
                .fontColor(Constants.COLOR_666666)
            }

          }
          .height(56)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (subIndex != items.length - 1) {
            Line()
              .height(0.5)
              .backgroundColor(Constants.COLOR_EEEEEE)
              .width('100%')
          }
        }
      }
      .backgroundColor(Color.White)
      .padding({left:12,right:12})
      .onClick(()=>this.confirmAction())
    })
  }

  build() {
    Navigation() {
      // NavigationBar()
      List({ space: 12 }) {
        ForEach(this.groupList, (items: Array<MineInfoItemModel>, index) => {
          ListItemGroup() {
            this.menuGroupItemView(items)
          }
          .borderRadius(16)
          .clip(true)

        }, (item: string): string => item)
      }
      .backgroundColor(Constants.COLOR_PAGE_BGC)
      .padding({ left: 13, right: 13, top: 12, bottom: 12 })

      Button('保存')
        .width('90%')
        .height(44)
        .backgroundColor(Constants.COLOR_ffcc33)
        .margin({top:30})
        .onClick(()=>{

        })
    }
    .navBarPosition(NavBarPosition.Start)
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title('编辑资料')
    .backButtonIcon($r('app.media.arrow_left_new'))
    .height('100%')
    .width('100%')
    .backgroundColor(Constants.COLOR_PAGE_BGC)

  }
}
