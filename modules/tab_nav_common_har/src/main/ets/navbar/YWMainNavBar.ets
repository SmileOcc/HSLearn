import { YWConstants } from "@learn/constants_har";
import { YWResColor, YWResImage } from "@learn/res_har";
import { ITabNavTitleConfig, TabNavTitleConfig } from "@learn/tab_nav_api_har";

@Component
export struct YWMainNavBar {

  @Prop navInfo?:ITabNavTitleConfig
  aboutToAppear(): void {
    let a = this.navInfo
  }

  build() {
    Row(){
      if (this.navInfo?.userAvatarInfo?.isShow && this.navInfo?.userAvatarInfo.icon) {
        //用户头像
        Row(){
          Image(this.navInfo?.userAvatarInfo.icon)
            .size({width:36,height:36})
        }
        .margin({right:8})
        .backgroundColor(YWConstants.RandomColor())
        .onClick(()=>{
          if(this.navInfo?.userAvatarInfo?.onClick) {
            this.navInfo.userAvatarInfo.onClick()
          }
        })
      } else if (this.navInfo?.backInfo?.isShow && this.navInfo.backInfo.icon) {
        //返回
        Row(){
          Image(this.navInfo.backInfo.icon)
            .size({width:36,height:36})
        }
        .margin({right:8})
        .backgroundColor(YWConstants.RandomColor())
      }

      if (this.navInfo?.titleInfo) {
        //标题
        Row(){
          Text(this.navInfo.titleInfo.title + (this.navInfo?.title ?? ""))
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .backgroundColor(YWConstants.RandomColor())
        .onClick(()=>{
          if (this.navInfo?.titleInfo?.onClick) {
            this.navInfo.titleInfo.onClick()
          }
        })
      }
      if (true) {
        //右边菜单
        Row(){
          Text("按钮")
          // if (this.navInfo?.rightMenuInfos.wrapItemBuilder) {
          //   ForEach(this.navInfo?.rightMenuInfos.wrapItemBuilder, (itemBuilder:WrappedBuilder<[]>) => {
          //     itemBuilder.builder()
          //
          //   })
          // }
        }
        .margin({left:8})
        .backgroundColor(YWConstants.RandomColor())

      }
    }
    .height(60)//TODO 默认高 normal 44 large 60    pad 20
    .width('100%')
    .padding({top:12, bottom:12, left:16, right:16})
    .backgroundColor(YWResColor.themeDefault())
  }
}