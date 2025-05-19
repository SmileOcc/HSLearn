import { HSLazyBaseModel } from './HSLazyBaseModel';

class HSLazyBaseDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: HSLazyBaseModel[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): HSLazyBaseModel {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

export class HSLazyDataSource extends HSLazyBaseDataSource {
  private dataArray: HSLazyBaseModel[] = [];

  constructor(dataArray: HSLazyBaseModel[]) {
    super();
    for (let i = 0; i < dataArray.length; i++) {
      this.dataArray.push(dataArray[i]);
    }
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): HSLazyBaseModel {
    return this.dataArray[index];
  }

  public addData(index: number, data: HSLazyBaseModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: HSLazyBaseModel): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
