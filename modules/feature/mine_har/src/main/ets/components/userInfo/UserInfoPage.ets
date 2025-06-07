import { YWBaseNavBar } from "@learn/baseui_har"
import { ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har"
import { HSAccountModel } from "@learn/userinfo_har"
import { MineInfoItemModel, MineInfoType } from "./model/MineInfoItemModel"
import { camera, cameraPicker } from "@kit.CameraKit"
import { common } from "@kit.AbilityKit"
import { YWConstants } from "@learn/constants_har"
import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { BusinessError } from "@kit.BasicServicesKit"
import { DialogBuilderParam, DialogTypeEnum, YWDialogUtils } from "@learn/common_har"
import { ImageEdit } from "./view/ImageEdit"
import { ImageEditParam } from "./model/ImageEditParam"
import { promptAction } from "@kit.ArkUI"
import { clearLoading, loading } from "../loading/Loading"
import { textRecognition } from "@kit.CoreVisionKit"
import { image } from "@kit.ImageKit"
import { fileIo as fs } from '@kit.CoreFileKit';


@Builder
function imageEditDialogBuilder(param: DialogBuilderParam) {
  ImageEdit({ param: param })
}

@Builder
export function userInfoBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    UserInfoPage({params: params})
  }
  .hideTitleBar(true)
}

@ComponentV2
struct UserInfoPage {
  // @StorageLink(Constants.kStorageLocalUser) localUseInf: UserInfoModel = new UserInfoModel()
  context: common.UIAbilityContext | undefined = (getContext(this) as common.UIAbilityContext);
  dialogId: string = '1';
  loadingId: number = -1;

  @Local localAvatar: string | undefined
  @Local pixel: image.PixelMap | undefined = undefined;
  @Monitor('pixel')
  pixelChange(monitor: IMonitor) {
    this.showPixelImage = true
  }
  @Local showPixelImage: boolean = false
  @Local albumPath: string = '';
  @Local photoSize: number = 0;

  @Local bottomHeight: number = 0; // 底部系统导航栏高度

  @Param params?: YWRouterNavParams | undefined = undefined
  @Param localUseInf: HSAccountModel = this.params?.itemInfo as HSAccountModel ?? new HSAccountModel("","","")
  //显示
  @Local showMenu: boolean = false;
  @Local groupList: Array<Array<MineInfoItemModel>> = [
    [
      {
        'infoType': MineInfoType.head,
        'title': '头像',
        'desc': '',
        'avatar': this.localUseInf.avatar ?? '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.nick,
        'title': '昵称',
        'desc': this.localUseInf.desc,
        'avatar': '',
        isArrow: true

      }
    ],
    [
      {
        'infoType': MineInfoType.name,
        'title': '姓名',
        'desc': this.localUseInf.nickName,
        'avatar': '',
        'isArrow': true

      },
      {
        'infoType': MineInfoType.sex,
        'title': '性别',
        'desc': this.localUseInf.sex + "",
        'avatar': '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.phone,
        'title': '手机号',
        'desc': this.localUseInf.phone,
        'avatar': '',
        'isArrow': false
      },
      {
        'infoType': MineInfoType.date,
        'title': '生日',
        'desc': this.localUseInf.birthday,
        'avatar': '',
        'isArrow': true
      }
    ]
  ]

  aboutToAppear(): void {

  }

  confirmAction() {

  }

  @Builder sexView(item:MineInfoItemModel) {
    Row(){

    }
  }

  @Builder
  builderMenus() {
    Column() {
      Text($r('app.string.addressrecognize_take_photo_button'))
        .margin('10vp')
        .fontSize('16vp')
        .onClick(() => {
          this.showMenu = false;
          this.takePhoto();
        })

      Divider().height(0.5).color($r('app.color.divider'));

      Text($r('app.string.addressrecognize_picker_button'))
        .margin('10vp')
        .fontSize('16vp')
        .onClick(() => {
          this.showMenu = false;
          this.imagePicker();
        })

      Divider().height(0.5).color($r('app.color.divider'));

      Text($r('app.string.addressrecognize_cancel_button'))
        .margin('10vp')
        .fontSize('16vp')
        .onClick(() => {
          this.showMenu = false;
        })

      Divider().height(0.5).color($r('app.color.divider'));
    }
    .width('100%')
    .height('150vp')
  }

  @Builder menuGroupItemView(items:Array<MineInfoItemModel>) {
    ForEach(items,(subItem:MineInfoItemModel,subIndex) => {
      ListItem() {
        Column(){
          Row(){
            Row(){
              Text(subItem.title)
                .fontSize(14)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
                .margin({left:12})
            }
            if (subItem.infoType == MineInfoType.head) {
              // Image(this.localAvatar ?? subItem.avatar)
              Image(this.pixel ?? subItem.avatar)
                .size({width:40,height:40})
                .objectFit(ImageFit.Fill)
                .borderWidth(0.5)
                .borderColor(Color.White)
                .borderRadius(20)
                .backgroundColor($r('app.color.col_EEEEEE'))
                .onClick(()=>{
                  this.showMenu = true;

                })
                .bindSheet($$this.showMenu, this.builderMenus(), {
                  height: "150vp",
                  backgroundColor: Color.White,
                  showClose: false
                })
            } else if (subItem.infoType == MineInfoType.sex) {
              this.sexView(subItem)
            } else if (subItem.isArrow) {
              Row(){
                if (subItem.infoType == MineInfoType.date) {
                  //按钮有间隙，改text
                  Button()
                  {
                    Text(subItem.desc ?? '请选择您的生日')
                      .fontColor(subItem.desc ? $r('app.color.col_666666') : $r('app.color.col_999999'))
                      .fontSize(13)
                  }
                  .buttonStyle(ButtonStyleMode.TEXTUAL)
                  .fontColor(subItem.desc ? $r('app.color.col_666666') : $r('app.color.col_999999'))
                  .fontSize(13)
                  .align(Alignment.End)
                } else {
                  Button(subItem.desc??'')
                    .buttonStyle(ButtonStyleMode.TEXTUAL)
                    .fontColor(subItem.desc ? $r('app.color.col_666666') : $r('app.color.col_999999'))
                    .fontSize(13)
                    .align(Alignment.End)

                }
                Image($r('app.media.arrow_right'))
                  .width(12)
                  .aspectRatio(1)
                  .margin({left:8})
              }
              .justifyContent(FlexAlign.End)
              .alignItems(VerticalAlign.Center)
              .onClick(()=>{

              })

            } else {
              Text(subItem.desc)
                .fontSize(13)
                .fontColor($r('app.color.col_666666'))
            }

          }
          .height(56)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          if (subIndex != items.length - 1) {
            Line()
              .height(0.5)
              .backgroundColor($r('app.color.col_EEEEEE'))
              .width('100%')
          }
        }
      }
      .backgroundColor(Color.White)
      .padding({left:12,right:12})
      .onClick(()=>this.confirmAction())
    })
  }

  build() {
    Column(){
      YWBaseNavBar({title:"个人中心", defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})

      if (this.pixel && this.showPixelImage) {
        Image(this.pixel)
          .size({width:200,height:200})
          .objectFit(ImageFit.Contain)
          .borderWidth(0.5)
          .borderColor(Color.White)
          // .borderRadius(20)
          .backgroundColor($r('app.color.col_EEEEEE'))
          .onClick(()=>{
            this.showPixelImage = false
          })

      }

      List({ space: 12 }) {
        ForEach(this.groupList, (items: Array<MineInfoItemModel>, index) => {
          ListItemGroup() {
            this.menuGroupItemView(items)
          }
          .borderRadius(16)
          .clip(true)

        }, (item: string): string => item)
      }
      .backgroundColor($r('app.color.bg_gray_base'))
      .padding({ left: 13, right: 13, top: 12, bottom: 12 })

      Button('保存')
        .width('90%')
        .height(44)
        .backgroundColor($r('app.color.col_FFCC33'))
        .margin({top:30})
        .onClick(()=>{

        })
    }
  }

  async handEditPhoto(image:object) {
    let pixelImage = image as image.PixelMap
    if (pixelImage) {
      this.pixel = pixelImage
    }
  }

  async handPhotoUrl(url: string) {
    //二者都可以直接显示
    this.localAvatar = url
    this.albumPath = url
    // 读取图片为buffer
    const file = fs.openSync(this.albumPath, fs.OpenMode.READ_ONLY);
    this.photoSize = fs.statSync(file.fd).size;
    console.info('Photo Size: ' + this.photoSize);
    let buffer = new ArrayBuffer(this.photoSize);
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);

    // 解码成PixelMap
    const imageSource = image.createImageSource(buffer);
    console.log('imageSource: ' + JSON.stringify(imageSource));
    this.pixel = await imageSource.createPixelMap({});
  }

  /**
   * 选择图库照片
   */
  imagePicker(): void {
    // 选择选项
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 过滤选择媒体文件类型为IMAGE
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 选择媒体文件的最大数目
    photoSelectOptions.maxSelectNumber = 1;
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      let uris = photoSelectResult.photoUris;
      if (uris.length > 0) {
        // this.handPhotoUrl(uris[0])
        // 打开照片裁剪弹窗
        this.openSnapshotEditDialog(uris[0]);
      }
    }).catch((err: BusinessError) => {
      console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  /**
   * 拍摄照片
   * @returns
   */
  async takePhoto(): Promise<void> {
    // 拉起拍照功能
    if (this.context) {
      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(this.context,
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
      if (pickerResult.resultCode === YWConstants.CAMERA_PICKER_RESULT_CODE_FAILURE) {
        // 当进入拍照页面点击X，直接返回原页面
        return;
      } else if (pickerResult.resultCode === YWConstants.CAMERA_PICKER_RESULT_CODE_SUCCESS) {
        // 打开照片裁剪弹窗
        this.openSnapshotEditDialog(pickerResult.resultUri);
      }
    }
  }

  /**
   * 打开图片裁剪弹窗
   * @param uri
   */
  openSnapshotEditDialog(uri: string): void {
    YWDialogUtils.showCustomDialog({
      dialogId: this.dialogId,
      builder: wrapBuilder(imageEditDialogBuilder),
      dialogType: DialogTypeEnum.BOTTOM,
      dialogBuilderParam: {
        onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
          if (isCloseDialog) {
            YWDialogUtils.closeCustomDialogById(this.dialogId);
            this.handEditPhoto(data)
            // loading($r('app.string.addressrecognize_recognize_text')).then((loadingId) => {
            //   this.loadingId = loadingId;
            //   this.recognizeImageToText(data);
            // });
          } else {
            promptAction.showToast({
              message: data,
              duration: 2000
            });
          }
        },
        data: new ImageEditParam(uri, this.bottomHeight)
      },
      isSlideToClose: false,
      isModalClosedByOverlayClick: false
    });
  }


  /**
   * 识别图片转文字
   * @param pixelMap
   */
  recognizeImageToText(pixelMap: image.PixelMap) {
    if (!pixelMap) {
      promptAction.showToast({
        message: $r('app.string.addressrecognize_recognize_image_fail_text'),
        duration: 2000
      });
      // 清除loading
      clearLoading(this.loadingId);
      return;
    }
    // 调用文本识别接口
    let visionInfo: textRecognition.VisionInfo = {
      pixelMap: pixelMap
    };
    let textConfiguration: textRecognition.TextRecognitionConfiguration = {
      isDirectionDetectionSupported: false
    };
    setTimeout(() => {
      try {
        textRecognition.recognizeText(visionInfo, textConfiguration,
          (error: BusinessError, data: textRecognition.TextRecognitionResult) => {
            // 识别成功，获取对应的结果
            if (error?.code == 0) {
              // 将结果更新到Text中显示
              // this.recognizeText = data.value;
            }
          });
      } catch (e) {
        promptAction.showToast({
          message: $r('app.string.addressrecognize_recognize_fail_text'),
          duration: 2000
        });
      } finally {
        // 清除loading
        clearLoading(this.loadingId);
      }
    }, 2000);
  }
}