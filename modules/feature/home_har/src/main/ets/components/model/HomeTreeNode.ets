import { HSLazyBaseModel } from "@learn/base_model_har";

@Observed
export class HomeTreeNode implements HSLazyBaseModel{
  expand: boolean = false;
  type: number | string | ESObject = 0
  title: string = ''
  url?: string = ''
  children?: HomeTreeNode[] = [];
}