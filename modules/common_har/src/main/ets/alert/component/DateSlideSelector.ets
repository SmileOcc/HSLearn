import { BasicDataSource } from "../../common/BasicDataSource";
import { DateSlideSelectorParam } from "../dto/DateSlideSelectorParam";
import { DialogBuilderParam } from "../dto/DialogBuilderParam";

@Component
export struct DateSlideSelector {
  @Prop param: DialogBuilderParam;
  @State @Watch("refreshMonthDatasource") selectYear: SlideData = new SlideData(2024);
  @State @Watch("refreshDayDataSource") selectMonth: SlideData = new SlideData(1);
  @State selectDay: SlideData = new SlideData(1);
  @State yearDataSource: BasicDataSource<SlideData> = new BasicDataSource();
  @State monthDataSource: BasicDataSource<SlideData> = new BasicDataSource();
  @State dayDataSource: BasicDataSource<SlideData> = new BasicDataSource();
  yearScroller: Scroller = new Scroller();
  monthScroller: Scroller = new Scroller();
  dayScroller: Scroller = new Scroller();
  minYear: number = 1900;
  minMonth: number = 1;
  minDay: number = new Date(this.minYear, this.minMonth, 0).getDate();
  maxYear: number = 2500;
  maxMonth: number = 12;
  maxDay: number = new Date(this.maxYear, this.maxMonth, 0).getDate();
  needChangeMonthDatasource: boolean = true;

  aboutToAppear(): void {
    let selectDate: Date = new Date();
    const selectorParam: DateSlideSelectorParam | undefined = this.param.data;
    if (selectorParam) {
      if (selectorParam.selectTime !== undefined) {
        selectDate = new Date(selectorParam.selectTime);
      }
      if (selectorParam.maxTime !== undefined) {
        const maxDate: Date = new Date(selectorParam.maxTime);
        this.maxYear = maxDate.getFullYear();
        this.maxMonth = maxDate.getMonth();
        this.maxDay = maxDate.getDate();
      }
      if (selectorParam.minTime !== undefined) {
        const minDate: Date = new Date(selectorParam.minTime);
        this.minYear = minDate.getFullYear();
        this.minMonth = minDate.getMonth();
        this.minDay = minDate.getDate();
      }
    }
    this.changeState(selectDate);
    this.initDataSource();
  }

  initDataSource() {
    for (let i = this.minYear; i <= this.maxYear; i++) {
      this.yearDataSource.pushData(new SlideData(i));
    }
    this.refreshMonthDatasource();
  }

  refreshMonthDatasource() {
    let tMaxMonth: number = 12;
    let tMinMonth: number = 1;
    if (this.selectYear.data === this.maxYear) {
      tMaxMonth = this.maxMonth;
      this.needChangeMonthDatasource = true;
    } else if (this.selectYear.data === this.minYear) {
      tMinMonth = this.minMonth;
      this.needChangeMonthDatasource = true;
    } else {
      this.needChangeMonthDatasource = false;
    }
    if (this.monthDataSource.totalCount() === 0 || this.needChangeMonthDatasource) {
      this.monthDataSource.clearAll();
      for (let i = tMinMonth; i <= tMaxMonth; i++) {
        this.monthDataSource.pushData(new SlideData(i));
      }

      this.monthDataSource.notifyDataReload();
      if (this.selectMonth.data < this.monthDataSource.getData(0).data) {
        this.monthScroller.scrollToIndex(0);
      } else if (this.selectMonth.data > this.monthDataSource.getData(this.monthDataSource.totalCount() - 1).data) {
        this.monthScroller.scrollToIndex(this.monthDataSource.totalCount() - 1);
      } else {
        this.monthScroller.scrollToIndex(this.selectMonth.data - this.monthDataSource.getData(0).data - 1)
      }
    }

    this.refreshDayDataSource();
  }

  refreshDayDataSource() {
    let tMaxDay: number = new Date(this.selectYear.data, this.selectMonth.data, 0).getDate();
    let tMinDay: number = 1;
    if (this.selectYear.data === this.maxYear && this.selectMonth.data === this.maxMonth) {
      tMaxDay = this.maxDay;
    } else if (this.selectYear.data === this.minYear && this.selectMonth.data === this.minMonth) {
      tMinDay = this.minDay;
    }
    if (this.dayDataSource.totalCount() === 0) {
      for (let i = tMinDay; i <= tMaxDay; i++) {
        this.dayDataSource.pushData(new SlideData(i));
      }
    } else if (tMaxDay === this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data &&
      tMinDay === this.dayDataSource.getData(0).data) {
      return;
    }

    if (tMinDay > this.dayDataSource.getData(0).data) {
      this.dayDataSource.spliceData(0, tMinDay - this.dayDataSource.getData(0).data);
    } else if (tMinDay < this.dayDataSource.getData(0).data) {
      for (let i = this.dayDataSource.getData(0).data - 1; i >= tMinDay; i--) {
        this.dayDataSource.unshift(new SlideData(i));
      }
    }

    if (tMaxDay < this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data) {
      this.dayDataSource.spliceData(tMaxDay,
        this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data - tMaxDay);
    } else if (tMaxDay > this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data) {
      for (let i = this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data + 1; i <= tMaxDay; i++) {
        this.dayDataSource.pushData(new SlideData(i));
      }
    }

    this.dayDataSource.notifyDataReload();
    if (this.selectDay.data < this.dayDataSource.getData(0).data) {
      this.dayScroller.scrollToIndex(0);
    } else if (this.selectDay.data > this.dayDataSource.getData(this.dayDataSource.totalCount() - 1).data) {
      this.dayScroller.scrollToIndex(this.dayDataSource.totalCount() - 1);
    } else {
      this.dayScroller.scrollToIndex(this.selectDay.data - this.dayDataSource.getData(0).data - 1)
    }
  }

  changeState(date: Date) {
    this.selectYear.data = date.getFullYear();
    this.selectMonth.data = date.getMonth() + 1;
    this.selectDay.data = date.getDate();
  }

  build() {
    Column() {
      Row() {
        Text("取消")
          .fontSize(16)
          .fontColor("#FF000000")
          .onClick(() => {
            this.param.closeDialog!();
          })
        Text("确认")
          .fontColor("#FF7096F9")
          .fontSize(16)
          .onClick(() => {
            this.param.onConfirm!(true,
              new Date(this.selectYear.data, this.selectMonth.data, this.selectDay.data).getTime());
          })
      }.padding({ left: 20, right: 20 })
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        this.slideSelector({
          dataSource: this.yearDataSource,
          selectData: this.selectYear,
          scroller: this.yearScroller
        })
        this.slideSelector({
          dataSource: this.monthDataSource,
          selectData: this.selectMonth,
          scroller: this.monthScroller
        })
        this.slideSelector({
          dataSource: this.dayDataSource,
          selectData: this.selectDay,
          scroller: this.dayScroller
        })
      }.width('100%')
      .height(120)
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('100%')
    .backgroundColor(Color.White)
    .height('25%')
  }

  @Builder
  slideSelector($$: SlideSelectorParam) {
    Stack() {
      Line()
        .width(50)
        .height(40)
        .stroke("#FF7096F9")
        .strokeWidth(1)
        .startPoint([0, 40])
        .endPoint([50, 40])
      List({ initialIndex: $$.selectData.data - $$.dataSource.getData(0).data, scroller: $$.scroller }) {
        LazyForEach($$.dataSource, (data: SlideData, index) => {
          ListItem() {
            Text(data.data + "")
              .fontSize(16)
              .opacity(data.data === $$.selectData.data ? 1 : 0.5);
          }.width(50)
          .height(40)
          .onClick(() => {
            $$.scroller.scrollToIndex(index - 1);
          })
        }, (item: SlideData, index) => item.data.toString())
      }
      .width(50)
      .height(120)
      .cachedCount(3)
      .onScrollIndex((start, center, end) => {
        let index = center - 1;
        if (start === center) {
          index = 0;
        } else if (center === end) {
          index = $$.dataSource.totalCount() - 1;
        }
        $$.selectData.data = $$.dataSource.getData(index).data;

      })
      .scrollBar(BarState.Off)
      .scrollSnapAlign(ScrollSnapAlign.CENTER)
    }.width('30%')
  }
}

interface SlideSelectorParam {
  dataSource: BasicDataSource<SlideData>;
  selectData: SlideData;
  scroller: Scroller;
}

@Observed
class SlideData {
  data: number;

  constructor(data: number) {
    this.data = data;
  }
}