import { mediaquery } from "@kit.ArkUI";
import { YWConstants } from "@learn/constants_har";
import { hsLog } from "@learn/logger_har";

export declare interface BreakpointTypeOption<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
  xl?: T
  xxl?: T
}

export class BreakPointType<T> {
  options: BreakpointTypeOption<T>

  constructor(option: BreakpointTypeOption<T>) {
    this.options = option
  }

  getValue(currentBreakPoint: string) {
    if (currentBreakPoint === 'xs') {
      return this.options.xs
    } else if (currentBreakPoint === 'sm') {
      return this.options.sm
    } else if (currentBreakPoint === 'md') {
      return this.options.md
    } else if (currentBreakPoint === 'lg') {
      return this.options.lg
    } else if (currentBreakPoint === 'xl') {
      return this.options.xl
    } else if (currentBreakPoint === 'xxl') {
      return this.options.xxl
    } else {
      return undefined
    }
  }
}

interface Breakpoint {
  name: string,
  size: number,
  mediaQueryListener?: mediaquery.MediaQueryListener
}

export enum BreakpointTypeEnum {
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl'
}

export function BreakpointTypeValue(type:BreakpointTypeEnum):number {
  switch (type) {
    case BreakpointTypeEnum.SM:
      return 320
    case BreakpointTypeEnum.MD:
      return 600
    case BreakpointTypeEnum.LG:
      return 840
    case BreakpointTypeEnum.XL:
      return 1500
  }
  return 320
}

const TAG = "BreakpointSystem"

export class BreakpointSystem {
  private currentBreakpoint: string = "md";
  private breakpoints: Breakpoint[] = [
    { name: 'sm', size: 320 },
    { name: 'md', size: 600 },
    { name: 'lg', size: 840 },
    { name: 'xl', size: 1500 }
  ];

  private updateCurrentBreakpoint(breakpoint: string) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.setOrCreate<string>(YWConstants.kCurrentBreakpoint, this.currentBreakpoint);
      hsLog.i(TAG,'on current breakpoint: ' + this.currentBreakpoint);
    }
  }

  // 设备横屏
  public register() {
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      let condition: string;
      if (index === this.breakpoints.length - 1) {
        condition = '(' + breakpoint.size + 'vp<=width' + ')';
      } else {
        condition = '(' + breakpoint.size + 'vp<=width<' + this.breakpoints[index + 1].size + 'vp)';
      }
      breakpoint.mediaQueryListener = mediaquery.matchMediaSync(condition);
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {// 若设备为横屏状态，更改相应的页面布局
          this.updateCurrentBreakpoint(breakpoint.name);
        }
      })
    })
  }

  public unregister() {
    this.breakpoints.forEach((breakpoint: Breakpoint) => {
      if (breakpoint.mediaQueryListener) {
        breakpoint.mediaQueryListener.off('change');
      }
    })
  }
}

export const osBreakpointSystem = new BreakpointSystem();
