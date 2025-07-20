import { kNode_Status_hide, kNode_Status_Show, NodeViewModel } from './NodeViewModel'
import { BuilderNode, UIContext } from '@kit.ArkUI'
import { ExtendNodeController } from './ExtenNodeController'

export abstract class UINodeViewModel<UIModel extends NodeViewModel> extends ExtendNodeController {

}