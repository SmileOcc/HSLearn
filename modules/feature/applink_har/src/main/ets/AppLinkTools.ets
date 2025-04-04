import { IAppLink } from "./core/IAppLink"

export class AppLinkTools {

  private  linkMaps: Map<string, IAppLink> = new Map()

  delayLink?:string
  handDelayJump() {

  }

  handleJump(url:string) {

    //url解析处理
    let urlLink = url
    let jumpLink = this.linkMaps.get(urlLink)
    if (jumpLink) {
      jumpLink.handleJump(url)
    } else {//通用解析处理

    }

  }

  registerAppLink(link:string,jumpLink:IAppLink) {
    this.linkMaps.set(link,jumpLink)
  }
}

export const appLinkTools = new AppLinkTools()