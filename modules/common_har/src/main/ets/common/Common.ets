
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';

const INDEX: number = 2;
const SLEEP_TIME: number = 10;
const RADIX: number = 16;

const TAG = 'pickerCommon';
const GRANT_MAX: number = 3;

export function reqPermissions(context:Context): void {
  let atManager = abilityAccessCtrl.createAtManager();
  const permissions: Array<Permissions> = [
    'ohos.permission.READ_MEDIA',
    'ohos.permission.WRITE_MEDIA',
    'ohos.permission.MEDIA_LOCATION',
    'ohos.permission.DISTRIBUTED_DATASYNC'
  ];
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    console.info(TAG, `[requestPermissions] data: ${JSON.stringify(data)}`);
    let grantStatus: Array<number> = data.authResults;
    let arrLength = grantStatus.length;
    if (arrLength < GRANT_MAX) {
      console.info(TAG, '[requestPermissions] Do not have 3 permissions.');
    } else {
      if (grantStatus[0] === 0 && grantStatus[1] === 0 && grantStatus[INDEX] === 0) {
        console.info(TAG, '[requestPermissions] Success to start request permissions.');
      } else {
        console.info(TAG, '[requestPermissions] Do not have permissions.');
      }
    }
  }).catch((err:Error) => {
    console.error(TAG, `[requestPermissions] Failed to start request permissions. Error: ${JSON.stringify(err)}`);
  });
}

export function strToUtf8Bytes(content: string | number | boolean): Array<number> {
  const code = encodeURIComponent(content);
  let bytes:Array<number> = [];
  for (let i = 0; i < code.length; i++) {
    const char = code.charAt(i);
    if (char === '%') {
      const hex = code.charAt(i + 1) + code.charAt(i + INDEX);
      const hexValue = parseInt(hex, RADIX);
      bytes.push(hexValue);
      i += INDEX;
    } else {
      bytes.push(char.charCodeAt(0));
    }
  }
  return bytes;
}

export function strToArrayBuffer(text: string): ArrayBuffer {
  const bytes:Array<number> = strToUtf8Bytes(text);
  const buffer = new ArrayBuffer(bytes.length);
  const bufView = new DataView(buffer);
  for (let i = 0; i < bytes.length; i++) {
    bufView.setUint8(i, bytes[i]);
  }
  return buffer;
}

export async function learnSleep(times: number): Promise<void> {
  if (!times) {
    times = SLEEP_TIME;
  }
  await new Promise<void>((res) => setTimeout(res, times));
}

export function randomString(num: number, chars: string): string {
  let len = num;
  let maxPos = chars.length;
  let pwd = '';
  for (let i = 0; i < len; i++) {
    pwd += chars.charAt(Math.floor(Math.random() * maxPos));
  }
  return pwd;
}

export function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}

export function stringToBuffer(content: string): Uint8Array {
  let textEncoder = new util.TextEncoder('utf-8');
  let resultBuf = textEncoder.encodeInto(content);
  return resultBuf;
}

