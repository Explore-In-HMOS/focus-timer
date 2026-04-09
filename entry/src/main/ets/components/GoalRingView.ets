import { DailyGoal } from '../model/GoalModel'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct GoalRingView {
  @ObjectLink goal: DailyGoal
  @State private animatedProgress: number = 0
  @State private showCelebration: boolean = false

  aboutToAppear() {
    setTimeout(() => {
      this.getUIContext()?.animateTo({ duration: 800, curve: Curve.EaseOut }, () => {
        this.animatedProgress = this.goal.progress * 100
      })
    }, 200)
  }

  build() {
    Column({ space: 4 }) {
      Stack() {
        Gauge({ value: this.animatedProgress, min: 0, max: 100 })
          .width(130)
          .height(130)
          .colors([[('#552586') as string, 0.3], [('#9969C7') as string, 0.6], [('#B589D6') as string, 1.0]])
          .strokeWidth(12)
          .description(this.buildDescription())

        if (this.showCelebration) {
          Text('Nice!')
            .fontSize(28)
            .offset({ y: -50 })
            .transition(TransitionEffect.scale({ x: 0, y: 0 }).animation({ duration: 500, curve: Curve.EaseOut }))
        }
      }

      Row({ space: 8 }) {
        Column() {
          Text(`${this.goal.completedMinutes}`)
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Text($r('app.string.minutes'))
            .fontSize(9)
            .fontColor('#888888')
        }

        Divider().vertical(true).height(24).color('#333333')

        Column() {
          Text(`${this.goal.targetMinutes}`)
            .fontSize(16)
            .fontColor('#888888')
            .fontWeight(FontWeight.Bold)
          Text($r('app.string.goal'))
            .fontSize(9)
            .fontColor('#888888')
        }
      }
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Center)
    .onAppear(() => {
      if (this.goal.isCompleted) {
        setTimeout(() => {
          this.getUIContext()?.animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
            this.showCelebration = true
          })
        }, 1000)
      }
    })
  }

  @Builder
  buildDescription() {
    Column({ space: 2 }) {
      Text(`${Math.round(this.goal.progress * 100)}%`)
        .fontSize(22)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
      Text($r('app.string.daily_goal'))
        .fontSize(9)
        .fontColor('#AAAAAA')
    }
  }
}
