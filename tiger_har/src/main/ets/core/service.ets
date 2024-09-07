import { TigerAppContext } from './TigerAppContext'
import { TigerGlobalThis } from './TigerGlobalThis';


export function bundleAppService():void {

  const appContext:TigerAppContext = new TigerAppContext()
  TigerGlobalThis.getInstance().setAppContext(appContext)

}

export function unBundleAppService():void {

  TigerGlobalThis.getInstance().clear()
}