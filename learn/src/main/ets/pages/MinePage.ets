import { display, promptAction } from '@kit.ArkUI';
import { Constants } from '../../../../../modules/common_har/src/main/ets/common/Constants';
import { GlobalContext } from '../../../../../modules/common_har/src/main/ets/common/GlobalContext';
import { UserInfoModel } from './accountInfo/model/UserInfoModel';
import { MineMainView } from './accountInfo/view/MineMainView';
import { common } from '@kit.AbilityKit';
// import { Logger } from '@yunkss/eftool';

let storage = LocalStorage.getShared()

@Entry(storage)
@Component
export default struct MinePage {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  @StorageLink(Constants.kStorageLocalUser) localUseInf: UserInfoModel = new UserInfoModel()
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    console.log('========== mine 1')
    console.log(`=========${Constants.screenWidth}`)
    console.debug("=====aboutToAppear ：mine" )

    console.log(`=========${px2vp(display.getDefaultDisplaySync().width)}`)

    let deviceDisplay: display.Display = GlobalContext.getContext().getObject('display') as display.Display;
    let url = 'file://' + GlobalContext.getContext().getObject("filesDir") + '/index.html'

    this.testPath()
  }
  onPageHide(): void {
    console.log('========== onPageHide')
  }
  onPageShow(): void {
    console.log('========== show')



  }

  testPath(){
    let applicationContext = this.context.getApplicationContext();
    let cacheDir = applicationContext.cacheDir;//<路径前缀>/<加密等级>/base/cache
    let tempDir = applicationContext.tempDir;
    let filesDir = applicationContext.filesDir;
    let databaseDir = applicationContext.databaseDir;
    let bundleCodeDir = applicationContext.bundleCodeDir;
    let distributedFilesDir = applicationContext.distributedFilesDir;
    let preferencesDir = applicationContext.preferencesDir;

    // 获取应⽤⽂件路径
    let filePath = tempDir + 'test.txt';
    console.debug(`====filePath: ${filePath}`);
    if (filePath !== null) {
      promptAction.showToast({
        message: filePath
      });
    }
  }

  build() {
    Column() {
      MineMainView({ userInfo: this.localUseInf })
      // Child()
    }
  }

  @Styles
  globalLine2(){
    .width(150)
    .height(1)
    .backgroundColor(Color.Black)
    // .globalLineSub() 不能加
  }
}

@Styles
function globalLineSub() {
  .width(150)
  .height(1)
  .backgroundColor(Color.Black)
}

@Styles
function globalLine() {
  .width(150)
  .height(1)
  .backgroundColor(Color.Black)
  // .globalLineSub()//不能加
}


//可惨
@Extend(Text) function titleColorSub(size:number){
  .fontColor(Color.Green)
  .fontSize(size)
  .fontStyle(FontStyle.Italic)
}

//可惨
@Extend(Text) function titleColor(size:number){
  .fontColor(Color.Green)
  .fontSize(size)
  .fontStyle(FontStyle.Italic)
  .titleColorSub(size)//可以加
}
