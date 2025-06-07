import { DateSlideSelector } from '../component/DateSlideSelector';
import { DialogBuilderParam } from '../dto/DialogBuilderParam';

/**
 * 日期滑动选择器
 * @param param
 */
@Builder
export function dateSlideSelectorBuilder(param: DialogBuilderParam) {
  DateSlideSelector({ param: param })
}