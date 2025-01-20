import { IUState } from '@learn/common_har';
import { ICatBasePage } from '../../base/ICatBasePage';
import { ICatModel } from '../../base/ICatMode'


export const CatAboutBuilder = wrapBuilder(aboutBuilder)

export interface IAboutParam extends ICatModel<IUState> {
  title?:string
  url?:string
}

@Builder
function aboutBuilder(data?:IAboutParam) {
  if (data != undefined) {
    CatAboutPage(data)
  } else {
    CatAboutPage()
  }
}


@Component
struct CatAboutPage{

  private title?:string


  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
  }

  build() {
    Column(){
      Text("about")
    }
    .size({width:'100%',height:'100%'})
  }
}