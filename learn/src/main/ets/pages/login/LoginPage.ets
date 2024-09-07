@Entry
@Component
struct LoginPage {
  @State message: string = 'Hello World';

  build() {
    Column({space:20}) {
      Image( 'logo .png')
      TextInput({placeholder:'用户名'})
      TextInput({placeholder:'密码'})
        .type(InputType.Password)
        .showPasswordIcon(true)
      Button('登录')
      Row(){
        Checkbox()
        Text('记住登录')
          .fontColor('#36D')
      }
    }
    .height('100%')
  }
}