import { common } from "@kit.AbilityKit";
import { ENU_CONTEXT, hsGlobalThis } from "@learn/common_har";
import { YWConstants } from "@learn/constants_har";
import { HSSearchComponent } from "@learn/search_har";
import { ITabNavParams } from "@learn/tab_nav_api_har";

export const HomeNavBarBuilder = wrapBuilder(homeNavBarBuilder)

@Builder
export function homeNavBarBuilder(params: ITabNavParams) {
  HomeNavBar()
}
  @Component
export struct HomeNavBar {
  @State searchInputWidth: number = 0;
  @StorageProp(YWConstants.kStatusBarHeight) statusBarHeight: number = 0
  @StorageProp(YWConstants.kStorageWidth) screenWidth: number = 0; //屏幕宽度（单位：vp）

  @StorageLink('context') UIContext: common.UIAbilityContext | undefined = hsGlobalThis.getObject<common.UIAbilityContext>(ENU_CONTEXT.UI_Root)

  @StorageLink('home_option_badge_clicked') homeOptionBadgeClicked: boolean = false;
  @StorageLink('home_option_plugin_button_clicked') homeOptionPluginButtonClicked: boolean = false;


  aboutToAppear(): void {
  }


  build() {
    Row(){
      HSSearchComponent()

      if (this.homeOptionBadgeClicked && this.homeOptionPluginButtonClicked) {
        Image($r('app.media.ic_public_drawer_filled'))
          .margin({ left: '8vp' })
          .width('24vp')
          .height('24vp')
          .onClick(() => {
            animateTo({
              duration: 300
            }, () => {
              // this.sideBarIsShow = true;
            })
          })
      } else {
        Badge({
          value: '',
          style: { badgeSize: 10, badgeColor: $r('app.color.home_option_badge_color') },
        }) {
          Image($r('app.media.ic_public_drawer_filled'))
            .margin({ left: '8vp' })
            .width('24vp')
            .height('24vp')
            .onClick(() => {
              animateTo({
                duration: 300
              }, () => {
                // this.sideBarIsShow = true;
                AppStorage.setOrCreate('home_option_badge_clicked', true);
                PersistentStorage.persistProp('home_option_badge_clicked', true);
              })
            })
        }
        .padding({
          right: '4vp'
        })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: $r('app.integer.search_component_search_foldable_padding1'),
      right: $r('app.integer.search_component_search_foldable_padding1')
    })
    .width('100%')
  }
}