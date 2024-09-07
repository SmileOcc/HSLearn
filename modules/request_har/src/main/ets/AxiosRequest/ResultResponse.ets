


//接口实现类包装
export class ResultResponse<T> {
  errorCode:number = 0
  errorMsg:string = ""
  data: T | null = null

  isSuccess(): boolean {
    return this.errorCode === 0
  }

  isSuccessWithData(): boolean {
    return this.errorCode === 0 && !!this.data
  }
}