import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import axios, { AxiosResponse } from '@ohos/axios';
import { BASE_URL, USER_LOGIN, USER_REGISTER } from './BaseUrlOne';
import { IServerResponseOne } from './ILoginResultOne';
import { MMKV } from '@tencent/mmkv';
import { YWShowToast } from '@learn/common_har/Index'
import { ILoginDataOne } from './ILoginDataOne';

let mmkv = MMKV.defaultMMKV()
@Entry
@Component
struct LoginPageOne {
  @State name: string = 'www12123';
  @State pass: string = '123456';

  controller: TextInputController = new TextInputController()
  @State handlePopup: boolean = false
  @State msg: string = ''
  @State btnenabled: boolean = true;
  @State checkStatus:boolean=false
  private context?: common.UIAbilityContext;

  build() {
    Column() {

      Image("https://tse2-mm.cn.bing.net/th/id/OIP-C.R6SvvWet47fnztOLem9WTAHaEn?rs=1&pid=ImgDetMain")
        .width('100%')
      Text("玩鸿蒙")
        .fontSize(38)
        .fontWeight(FontWeight.Bold)
        .fontColor('#4a9deb')
        .margin({top:30})
      Text("WANHARMONY")
        .fontSize(20)
        .margin({top:10})
        .fontWeight(FontWeight.Bold)
        .fontColor('#4a9deb')
      Text()
        .height(60)


      Row(){
        Image($r('app.media.yonghu'))
          .height(18)
          .width(18)

        TextInput({ text: this.name, placeholder: '输入账号', controller: this.controller })
          .placeholderFont({ size: 16, weight: 400 })
          .width(180)
          .height(35)
          .maxLength(12)
          .backgroundColor("#f8f8f8")
          .onChange((value: string) => {
            this.name = value
          })
          .margin({left:10})
      }
      .padding({left:20})
      .width('80%')
      .borderRadius(20)
      .backgroundColor("#f8f8f8")


      Row(){
        Image($r('app.media.mima'))
          .height(18)
          .width(18)

        TextInput({ text: this.pass, placeholder: '输入密码', controller: this.controller })
          .placeholderFont({ size: 16, weight: 400 })
          .width(180)
          .height(35)
          .backgroundColor("#f8f8f8")
          .maxLength(12)
          .showPasswordIcon(false)
          .type((InputType.Password))
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value: string) => {
            this.pass = value
          })

      }
      .margin({top:20})
      .padding({left:20})
      .width('80%')
      .borderRadius(20)
      .backgroundColor("#f8f8f8")



      Text("注册")
        .width('100%')
        .height(45)
        .textAlign(TextAlign.End)
        .padding({right:50,top:20})
        .fontColor("#4a9deb")
        .onClick(()=>{
          router.pushUrl({url:"pages/base/registerlogin/RegisterPageOne"})
        })

      Button("登 录")
        .type(ButtonType.Normal)
        .backgroundColor('#4a9deb')
        .width('75%')
        .fontSize(20)
        .height(50)
        .margin({top:20})
        .borderRadius(5)
        .enabled(this.btnenabled)

        .onClick(() => {

          if (this.checkStatus) {
            let userInfo: ILoginDataOne = { username: this.name, password: this.pass}

            this.userLogin(userInfo)
          }else {
            YWShowToast("请阅读并勾选同意相关协议")
          }
        })



      Row(){
        Checkbox({name: 'checkbox2',  group: 'checkboxGroup'})
          .select(false)
          .selectedColor(0x39a2db)
          .onChange((value: boolean) => {
            if (value) {
              this.checkStatus=true
            }else {
              this.checkStatus=false
            }
          })


        Text(){
          Span("我已阅读并同意")
            .fontSize(12)
          Span("法律声明及隐私协议")
            .fontColor("#4a9deb")
            .fontSize(12)
            .onClick(()=>{
              YWShowToast("隐私协议")
            })
          Span("和")
            .fontSize(12)

          Span("用户协议")
            .fontColor("#4a9deb")
            .fontSize(12)
            .onClick(()=>{
              YWShowToast("用户协议")
            })
        }

      }
      .margin({top:15})



    }
  }

  private userLogin(userInfo: ILoginDataOne){


    axios({ url: BASE_URL+"/"+USER_LOGIN, method: 'post',params: { username: userInfo.username, password: userInfo.password} })
      .then((response: AxiosResponse<string>) => {
        let cookie=JSON.stringify(response.headers['set-cookie'] as  string[]);
        mmkv.encodeString('cookie', cookie);
        let responseObject:IServerResponseOne = JSON.parse(JSON.stringify(response.data));
        if (responseObject.errorCode==0) {
          // showToast("用户登录成功")
          router.pushUrl({url:"pages/HomeRoutePage"})
        }else {
          YWShowToast(responseObject.errorMsg)
        }
      })
      .catch((error:Error) => {
        console.info(JSON.stringify(error));
      });
  }
}