/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * HomePage TabBar model
 */
export class TabDataModel {
  // tabId
  id: number = 0;
  // tab category data
  navData: string | undefined = undefined;

  constructor(id: number, navData: string) {
    this.navData = navData;
    this.id = id;
  }
}

export const TAB_DATA: Array<TabDataModel> = [
  new TabDataModel(0, '推荐'),
  new TabDataModel(1, '手机'),
  new TabDataModel(2, '电脑'),
  new TabDataModel(3, '音箱'),
  new TabDataModel(4, '折叠'),
  new TabDataModel(5, '平板'),
];

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: TabDataModel[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): TabDataModel {
    return this.originDataArray[index];
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

export class TabDataSource extends BasicDataSource {
  private dataArray: TabDataModel[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): TabDataModel {
    return this.dataArray[index];
  }

  public addData(index: number, data: TabDataModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: TabDataModel): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}