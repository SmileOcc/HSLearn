@ObservedV2
class YWValueWrapperV2<T> {
  @Trace value: T //加@Trace value变化可触发ui渲染
  constructor(value: T) {
    this.value = value
  }
}

export default YWValueWrapperV2;
