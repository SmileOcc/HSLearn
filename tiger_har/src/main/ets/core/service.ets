import { TigerAppContext } from './TigerAppContext'
import { TigerGlobalThis } from './TigerGlobalThis';
import { TigerServerProvider } from './TigerServerProvider';


export function bundleAppService():void {

  const appContext:TigerAppContext = new TigerAppContext()
  TigerGlobalThis.getInstance().setAppContext(appContext)

  TigerServerProvider.bundleAppService(appContext)

}

export function unBundleAppService():void {

  TigerGlobalThis.getInstance().clear()
  TigerServerProvider.unBundleAppService()
}