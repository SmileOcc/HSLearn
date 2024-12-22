import hilog from '@ohos.hilog';

class BuildProfile {
  static DEBUG: boolean = true;
}

/**
 * 日志类
 */

class YWLogger {
  private domain: number;
  private prefix: string;
  private format: string = `%{public}s , %{public}s`;

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  d(...args: string[]) {
    if (BuildProfile.DEBUG) {
      hilog.debug(this.domain, this.prefix, this.format, args);
    }
  }

  i(...args: string[]) {
    if (BuildProfile.DEBUG) {
      hilog.info(this.domain, this.prefix, this.format, args);
    }
  }

  w(...args: string[]) {
    if (BuildProfile.DEBUG) {
      hilog.warn(this.domain, this.prefix, this.format, args);
    }
  }

  e(...args: string[]) {
    if (BuildProfile.DEBUG) {
      hilog.error(this.domain, this.prefix, this.format, args);
    }
  }

  f(...args: string[]) {
    if (BuildProfile.DEBUG) {
      hilog.fatal(this.domain, this.prefix, this.format, args);
    }
  }

  isLoggable(level: number) {
    if (BuildProfile.DEBUG) {
      hilog.isLoggable(this.domain, this.prefix, level);
    }
  }
}

export let hsLog = new YWLogger('==HSLearn');
