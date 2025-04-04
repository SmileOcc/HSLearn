
export class HSError extends Error {
  name: string
  message: string
  stack?: string;
  errorCode: number
  error?: Error

  constructor(message:string,code:number,error:Error,stack?:string) {
    super(message);
    this.name = this.constructor.name
    this.stack = stack ?? new Error().stack
    this.errorCode = code
    this.message = message
    this.error = this.error
  }
}