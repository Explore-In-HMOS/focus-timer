import { Achievement, AchievementProgress } from '../model/Achievement'

@Component
export default struct BadgeCard {
  @Prop achievement: Achievement
  @Prop progress: AchievementProgress
  @State private scaleVal: number = 1.0

  build() {
    Column({ space: 4 }) {
      Stack() {
        Circle()
          .width(44)
          .height(44)
          .fill(this.progress.unlocked ? '#552586' : '#2A2A2A')
          .scale({ x: this.scaleVal, y: this.scaleVal })

        SymbolGlyph(this.achievement.icon)
          .fontSize(20)
          .fontColor([this.progress.unlocked ? Color.White : '#666666'])

        if (!this.progress.unlocked) {
          Circle()
            .width(44)
            .height(44)
            .fill('#00000088')

          SymbolGlyph($r('sys.symbol.lock_fill'))
            .fontSize(14)
            .fontColor(['#888888'])
        }
      }

      Text(this.achievement.name)
        .fontSize(10)
        .fontColor(this.progress.unlocked ? Color.White : '#888888')
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (!this.progress.unlocked) {
        Progress({ value: this.progress.currentValue, total: this.achievement.targetValue })
          .width(44)
          .height(4)
          .color('#552586')
          .backgroundColor('#333333')
          .style({ strokeWidth: 4 })
      }
    }
    .width(60)
    .padding(4)
    .onClick(() => {
      if (this.progress.unlocked) {
        this.getUIContext()?.animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
          this.scaleVal = 1.2
        })
        setTimeout(() => {
          this.getUIContext()?.animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
            this.scaleVal = 1.0
          })
        }, 300)
      }
    })
  }
}
