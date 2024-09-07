import hilog from '@ohos.hilog';

/**
 * Common log for all features.
 */
class KLogger {
  private domain: number;
  private prefix: string;
  // private format: string = '%{public}s, %{public}s';
  private format: string = '%{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }

  fatal(...args: string[]): void {
    hilog.fatal(this.domain, this.prefix, this.format, args);
  }

  isLoggable(level: number): void {
    hilog.isLoggable(this.domain, this.prefix, level);
  }
}

export default new KLogger('===HMOS');
