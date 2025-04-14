import { hsLog } from "@learn/logger_har";
import { YWLocalNavType, ywNavManager, YWRouterNavParams } from "@learn/nav_router_har";
import { YWResColor } from "@learn/res_har";
import { asyncLocalStage, GlobalService, YWGlobalServiceManager, YWLazy } from "@learn/global_service_har"
import { tabMainBuilder, TabMainNavPage } from "@learn/tab_nav_har/src/main/ets/core/TabMainNavPage";

const TAG = "MainPage"
@Component
struct MainPage {


  @State navigationMode: number = NavigationMode.Stack;

  @Consume('isFullScreen') isFullScreen: boolean;


  @State isShowLeft:boolean = false

  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
  }


  build() {
    Stack() {

      tabMainBuilder()

      if(this.isShowLeft) {
        Column(){

        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Gray)
        .onClick(()=>{
          this.isShowLeft = false
        })

        Column(){


        }
        .width('70%')
        .height('100%')
        .backgroundColor(Color.White)

      }


    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
  }
}

@Builder
export function learnMainBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    MainPage({},asyncLocalStage(()=>{
      return new LocalStorage()
    }))
  }
  .hideTitleBar(true)
  .onBackPressed(()=>{

    return true
  })
}