import { FocusType, focusName } from '../model/FocusType'

@CustomDialog
export struct SessionCompleteDialog {
  controller: CustomDialogController
  focusType: FocusType = FocusType.focus
  duration: number = 0
  onDismiss: () => void = () => {}

  build() {
    Column({ space: 12 }) {
      // Icon
      SymbolGlyph($r('sys.symbol.checkmark_circle_fill'))
        .fontSize(36)
        .fontColor(['#4CAF50'])

      Text($r('app.string.session_complete'))
        .fontSize(16)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      // Session info
      Row({ space: 8 }) {
        Column() {
          Text(focusName(this.focusType, true))
            .fontSize(11)
            .fontColor('#AAAAAA')
          Text(`${Math.floor(this.duration / 60)} min`)
            .fontSize(16)
            .fontColor(Color.White)
        }
      }

      Button() {
        Text($r('app.string.continue'))
          .fontColor(Color.White)
          .fontSize(12)
      }
      .width('80%')
      .height(32)
      .backgroundColor('#552586')
      .borderRadius(16)
      .onClick(() => {
        this.onDismiss()
        this.controller.close()
      })
    }
    .padding(14)
    .width('86%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#1A1A1A')
    .borderRadius(18)
  }
}

@CustomDialog
export struct ConfirmDialog {
  controller: CustomDialogController
  title: ResourceStr = ''
  message: ResourceStr = ''
  onConfirm: () => void = () => {}

  build() {
    Column({ space: 12 }) {
      Text(this.title)
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      Text(this.message)
        .fontSize(11)
        .fontColor('#AAAAAA')
        .textAlign(TextAlign.Center)

      Row({ space: 12 }) {
        Button() {
          Text($r('app.string.cancel'))
            .fontColor('#AAAAAA')
            .fontSize(11)
        }
        .layoutWeight(1)
        .height(28)
        .backgroundColor('#333333')
        .borderRadius(14)
        .onClick(() => this.controller.close())

        Button() {
          Text($r('app.string.confirm'))
            .fontColor(Color.White)
            .fontSize(11)
        }
        .layoutWeight(1)
        .height(28)
        .backgroundColor('#552586')
        .borderRadius(14)
        .onClick(() => {
          this.onConfirm()
          this.controller.close()
        })
      }
      .width('100%')
    }
    .padding(14)
    .width('86%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#1A1A1A')
    .borderRadius(18)
  }
}

@CustomDialog
export struct AchievementUnlockDialog {
  controller: CustomDialogController
  achievementName: ResourceStr = ''
  achievementIcon: Resource = $r('sys.symbol.star_fill')

  @State private iconScale: number = 0.0

  aboutToAppear() {
    setTimeout(() => {
      this.getUIContext()?.animateTo({
        duration: 600,
        curve: Curve.EaseOut,
      }, () => {
        this.iconScale = 1.0
      })
    }, 100)
  }

  build() {
    Column({ space: 12 }) {
      Stack() {
        Circle()
          .width(56)
          .height(56)
          .fill('#552586')
          .scale({ x: this.iconScale, y: this.iconScale })

        SymbolGlyph(this.achievementIcon)
          .fontSize(28)
          .fontColor([Color.White])
          .scale({ x: this.iconScale, y: this.iconScale })
      }

      Text($r('app.string.achievement_unlocked'))
        .fontSize(13)
        .fontColor('#FFD700')
        .fontWeight(FontWeight.Bold)

      Text(this.achievementName)
        .fontSize(11)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)

      Button() {
        Text($r('app.string.awesome'))
          .fontColor(Color.White)
          .fontSize(11)
      }
      .width('70%')
      .height(28)
      .backgroundColor('#552586')
      .borderRadius(14)
      .onClick(() => this.controller.close())
    }
    .padding(14)
    .width('86%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#1A1A1A')
    .borderRadius(18)
  }
}
