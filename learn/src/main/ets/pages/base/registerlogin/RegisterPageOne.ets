import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { BASE_URL, USER_REGISTER } from './BaseUrlOne';
import axios, { AxiosResponse } from '@ohos/axios';
import { IServerResponseOne } from './ILoginResultOne';
import { YWShowToast } from '@learn/common_har';
import { ILoginDataOne } from './ILoginDataOne';

@Entry
@Component
struct RegisterPageOne {
  @State name: string = '';
  @State pass: string = '';
  @State repass:string=''
  controller: TextInputController = new TextInputController()
  @State msg: string = ''
  @State btnenabled: boolean = true;

  build() {
    Column() {


      Text("玩鸿蒙用户注册")
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
          .type((InputType.Number))
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

          .onChange((value: string) => {
            this.pass = value
          })

      }
      .margin({top:20})
      .padding({left:20})
      .width('80%')
      .borderRadius(20)
      .backgroundColor("#f8f8f8")


      Row(){
        Image($r('app.media.mima'))
          .height(18)
          .width(18)

        TextInput({ text: this.repass, placeholder: '确认密码', controller: this.controller })
          .placeholderFont({ size: 16, weight: 400 })
          .width(180)
          .height(35)
          .backgroundColor("#f8f8f8")
          .maxLength(12)
          .showPasswordIcon(false)
          .type((InputType.Password))

          .onChange((value: string) => {
            this.repass = value
          })

      }
      .margin({top:20})
      .padding({left:20})
      .width('80%')
      .borderRadius(20)
      .backgroundColor("#f8f8f8")


      Text("")
        .width('100%')
        .height(45)
        .textAlign(TextAlign.End)
        .fontColor("#4a9deb")


      Button("注 册")
        .type(ButtonType.Normal)
        .backgroundColor('#4a9deb')
        .width('75%')
        .fontSize(20)
        .height(50)
        .margin({top:10})
        .borderRadius(5)
        .enabled(this.btnenabled)

        .onClick(() => {
          if (this.name=='' || this.pass=='') {
            YWShowToast("用户名和密码不能为空")
          }else {
            let userInfo: ILoginDataOne = { username: this.name, password: this.pass, repassword: this.repass }

            this.userLogin(userInfo)
          }
        })







    }

  }
  private userLogin(userInfo: ILoginDataOne){


    axios({ url: BASE_URL+"/"+USER_REGISTER, method: 'post', params: { username: userInfo.username, password: userInfo.password, repassword:userInfo.repassword} })
      .then((response: AxiosResponse<string>) => {

        console.info(JSON.stringify(response));
        let responseObject:IServerResponseOne = JSON.parse(JSON.stringify(response));
        if (responseObject.errorCode==0) {
          YWShowToast("注册成功")
          router.back()
        }else {
          YWShowToast(responseObject.errorMsg)
        }
      })
      .catch((error:Error) => {
        console.info(JSON.stringify(error));
      });
  }




}
