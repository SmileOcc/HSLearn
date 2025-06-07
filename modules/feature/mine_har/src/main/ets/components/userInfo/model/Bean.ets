export class RectPosition {
  x:number = 0;
  y:number = 0;
  width:number = 0;
  height:number =  0;
}

export class InitPosition {
  x:number = 0;
  y:number = 0;
  width:number = 0;
  height:number =  0;
}

export class Position {
  x:number = 0;
  y:number = 0;
}

export enum ActionType {
  topLeft = 0,
  bottomLeft = 1,
  topRight = 2,
  bottomRight = 3,
  move = 4
}