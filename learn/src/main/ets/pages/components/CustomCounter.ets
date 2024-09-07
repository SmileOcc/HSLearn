@Preview
@Component
struct DecIcon {
  private click: () => void = () => {
  };

  build() {
    Stack() {
      Line()
        .startPoint([0, 0])
        .endPoint([12, 0])
        .stroke(Color.White)
        .strokeWidth(2)
        .strokeLineCap(LineCapStyle.Round)
    }
    .borderRadius(10)
    .backgroundColor('#35BD6A')
    .width(20)
    .height(20)
    .opacity(0.4)
    .onClick(() => {
      this.click()
    })
  }
}

@Preview
@Component
struct IncIcon {
  private readonly click: () => void = () => {
  };

  build() {
    Stack() {
      Line()
        .startPoint([0, 0])
        .endPoint([0, 12])
        .stroke(Color.White)
        .strokeWidth(2)
        .strokeLineCap(LineCapStyle.Round)
    }
    .borderRadius(10)
    .backgroundColor('#35BD6A')
    .width(20)
    .height(20)
    .onClick(() => {
      this.click()
    })
  }
}

@Component
export struct CustomCounter {
  @Prop value: string = '';
  private onDec: () => void = () => {
  };
  private onInc: () => void = () => {
  };

  build() {
    Row() {
      DecIcon({ click: this.onDec })
      Text(this.value).margin({ left: 11, right: 11 })
      IncIcon({ click: this.onInc })
    }
  }
}

@Preview
@Entry
@Component
struct PreviewCustomCounter {
  @State weight: number = 50

  build() {
    Row() {
      CustomCounter({
        value: this.weight + 'g',
        onDec: () => {
          this.weight -= 50
        },
        onInc: () => {
          this.weight += 50
        }
      })
    }
  }
}