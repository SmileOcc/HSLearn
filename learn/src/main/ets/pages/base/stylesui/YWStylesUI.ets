import { YWConstants } from '@learn/constants_har'

@Styles
function bottomHeightStyle() {
  .padding({ bottom:Number(AppStorage.get(YWConstants.kSafeBottomHeight)) })
}

@Styles
function statusHeightStyle() {
  .padding({ bottom:Number(AppStorage.get(YWConstants.kStatusBarHeight)) })
}
