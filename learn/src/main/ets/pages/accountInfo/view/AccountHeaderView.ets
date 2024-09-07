import { UserInfoModel } from '../model/UserInfoModel'

@Component
export struct AccountHeaderView {
  @Link @Watch('userInfoChange') infoModel: UserInfoModel;

  userInfoChange(user: UserInfoModel) {
    console.log('====== userInfoChange')
  }

  aboutToAppear(): void {

  }
  onPageShow(): void {//组件这个不生效，仅@entry页面生效
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image(this.infoModel.img)
            .size({ width: 56, height: 56 })
            .backgroundColor(Color.Blue)
            .opacity(0.5)
          Column() {
            if (this.infoModel.userToken != undefined) {
              Text(this.infoModel.name)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
              Text(this.infoModel.desc)
                .fontSize(12)
                .fontColor(Color.Gray)
            } else {
              Text('点击登录\注册')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
            }
          }

        }
        Row(){
          Text('个人主页')
            .fontColor(Color.Gray)
            .fontSize(13)
          Image('')
        }
      }
    }
    .width('100%')
  }
}