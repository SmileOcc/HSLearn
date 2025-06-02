import { util } from "@kit.ArkTS";
import { resourceManager } from "@kit.LocalizationKit";


let jsonPath: string = 'test_hotel_db.json';

class HSTestMockManager {
  private mockJsonObj?: Record<string, object>
  constructor() {
  }

  setContext(context: Context) {

    let rawFile: Uint8Array;
    try {
      let resourceManager = context.getApplicationContext().resourceManager;

      rawFile = resourceManager.getRawFileContentSync(jsonPath);
      let mockStr: string = util.TextDecoder.create("utf-8", { ignoreBOM: true }).decodeToString(rawFile);
      let jsonObj: Record<string, Object> = JSON.parse(mockStr);
      this.mockJsonObj = jsonObj

      this.getHotelList()
    } catch (error) {
      let err = JSON.stringify(error)
      let k = ""
    }
  }

  getHotelList(): object[]  {
    let list = this.mockJsonObj?.['hotelList']
    if (list && list instanceof Array) {
      return list
    }
    return []
  }

  reqHotelRoomList(): object[] {
    let list = this.mockJsonObj?.['roomList']
    if (list && list instanceof Array) {
      return list
    }
    return []
  }

  reqCommentsList(): object[] {
    let list = this.mockJsonObj?.['comments']
    if (list && list instanceof Array) {
      return list
    }
    return []
  }

}

export let hsMockManager = new HSTestMockManager()

async function checkMock(resourceManager: resourceManager.ResourceManager) {
  let rawFile: Uint8Array;
  try {
    rawFile = resourceManager.getRawFileContentSync(jsonPath);
    let mockStr: string = util.TextDecoder.create("utf-8", { ignoreBOM: true }).decodeToString(rawFile);
    let mockMap: Record<string, string> = getMockList(mockStr);

  } catch (error) {
  }
}

function getMockList(jsonStr: string) {
  let jsonObj: Record<string, Object> = JSON.parse(jsonStr);
  let map: Map<string, object> = new Map<string, object>(Object.entries(jsonObj));
  let mockList: Record<string, string> = {};
  map.forEach((value: object, key: string) => {
    let realValue: string = value['source'].toString();
    mockList[key] = realValue;
  });
  return mockList;
}