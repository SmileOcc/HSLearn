import { AppStorageV2, mediaquery } from "@kit.ArkUI";
import { YWConstants } from "@learn/constants_har";
import { hsLog } from "@learn/logger_har";
import YWValueWrapperV2 from "./YWValueWrapperV2";

// 宽度类型	取值范围(vp)	设备描述
// xs	[0,320)	最小宽度类型设备
// sm	[320,520)	小宽度类型设备
// md	[520,840)	中等宽度类型设备
// lg	[840,+∞)	大宽度类型设备
// xl‌：超大宽度设备，屏幕宽度在1200像素以上‌

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

export enum BreakpointTypeEnumValue {
  SM = 320,
  MD = 600,
  LG = 840,
  XL = 1500
}

export function BreakpointTypeValue(type:BreakpointTypeEnum | string):BreakpointTypeEnumValue {
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
      let currentBreakpointValue:number = BreakpointTypeValue(this.currentBreakpoint)
      AppStorage.setOrCreate<string>(YWConstants.kCurrentBreakpoint, this.currentBreakpoint);
      AppStorage.setOrCreate<number>(YWConstants.kCurrentBreakpointValue, currentBreakpointValue);

      AppStorageV2.connect(YWValueWrapperV2, YWConstants.kCurrentBreakpoint, ()=> new YWValueWrapperV2(this.currentBreakpoint))
      AppStorageV2.connect(YWValueWrapperV2, YWConstants.kCurrentBreakpointValue, ()=> new YWValueWrapperV2(currentBreakpointValue))

      hsLog.i(TAG,'on current breakpoint: ' + this.currentBreakpoint + ' --> ' + currentBreakpointValue);
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




// export class BreakpointSystem {
//   private currentBreakpoint: string = 'sm';
//   private xsListener: mediaQuery.MediaQueryListener;
//   private smListener: mediaQuery.MediaQueryListener;
//   private mdListener: mediaQuery.MediaQueryListener;
//   private lgListener: mediaQuery.MediaQueryListener;
//
//   public register(): void {
//     this.xsListener = mediaQuery.matchMediaSync('(width<320vp)');
//     this.xsListener.on('change', this.isBreakpointXS);
//     this.smListener = mediaQuery.matchMediaSync('(320vp<=width<600vp)');
//     this.smListener.on('change', this.isBreakpointSM);
//     this.mdListener = mediaQuery.matchMediaSync('(600vp<=width<840vp)');
//     this.mdListener.on('change', this.isBreakpointMD);
//     this.lgListener = mediaQuery.matchMediaSync('(840vp<=width)');
//     this.lgListener.on('change', this.isBreakpointLG);
//   }
//
//   public unregister(): void {
//     this.xsListener.off('change', this.isBreakpointXS);
//     this.smListener.off('change', this.isBreakpointSM);
//     this.mdListener.off('change', this.isBreakpointMD);
//     this.lgListener.off('change', this.isBreakpointLG);
//   }
//
//   private isBreakpointXS = (mediaQueryResult: mediaQuery.MediaQueryResult): void => {
//     if (mediaQueryResult.matches) {
//       this.updateCurrentBreakpoint('xs');
//     }
//   }
//
//   private isBreakpointSM = (mediaQueryResult: mediaQuery.MediaQueryResult): void => {
//     if (mediaQueryResult.matches) {
//       this.updateCurrentBreakpoint('sm');
//     }
//   }
//
//   private isBreakpointMD = (mediaQueryResult: mediaQuery.MediaQueryResult): void => {
//     if (mediaQueryResult.matches) {
//       this.updateCurrentBreakpoint('md');
//     }
//   }
//
//   private isBreakpointLG = (mediaQueryResult: mediaQuery.MediaQueryResult): void => {
//     if (mediaQueryResult.matches) {
//       this.updateCurrentBreakpoint('lg');
//     }
//   }
//
//   private updateCurrentBreakpoint(breakpoint: string): void {
//     if (this.currentBreakpoint !== breakpoint) {
//       this.currentBreakpoint = breakpoint;
//       AppStorage.SetOrCreate<string>('currentBreakpoint', this.currentBreakpoint);
//     }
//   }
// }

