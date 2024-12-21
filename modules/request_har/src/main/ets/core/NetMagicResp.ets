
export class NetMagicResp<T> {
  static SUCCESS_CODE: number = 1;
  data: T;
  code: number;
  message: string;
  timestamp: number = 0;
  executeTime: number = 0;

  constructor(data: T, code: number, message: string) {
    this.data = data;
    this.code = code;
    this.message = message;
  }
}