import { SizeConstants } from '../constants/SizeConstants'

interface BreakActivity {
  icon: Resource
  name: Resource
  description: Resource
  durationSeconds: number
  color: string
}

@Component
export default struct BreakSuggestions {
  @State private currentIndex: number = 0
  @State private miniTimer: number = 0
  @State private miniRunning: boolean = false
  private miniIntervalId: number = -1
  private activities: BreakActivity[] = [
    { icon: $r('sys.symbol.figure_walk'), name: $r('app.string.break_walk'), description: $r('app.string.break_walk_desc'), durationSeconds: 120, color: '#4CAF50' },
    { icon: $r('sys.symbol.drop_fill'), name: $r('app.string.break_water'), description: $r('app.string.break_water_desc'), durationSeconds: 30, color: '#2196F3' },
    { icon: $r('sys.symbol.moon_fill'), name: $r('app.string.break_eyes'), description: $r('app.string.break_eyes_desc'), durationSeconds: 60, color: '#FF9800' },
    { icon: $r('sys.symbol.figure_walk'), name: $r('app.string.break_stretch'), description: $r('app.string.break_stretch_desc'), durationSeconds: 90, color: '#E91E63' },
    { icon: $r('sys.symbol.heart_fill'), name: $r('app.string.break_relax'), description: $r('app.string.break_relax_desc'), durationSeconds: 60, color: '#9C27B0' },
    { icon: $r('sys.symbol.face_smiling'), name: $r('app.string.break_smile'), description: $r('app.string.break_smile_desc'), durationSeconds: 30, color: '#00BCD4' },
  ]

  aboutToDisappear() {
    if (this.miniIntervalId !== -1) {
      clearInterval(this.miniIntervalId)
    }
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.activities, (activity: BreakActivity, index: number) => {
          Column({ space: 6 }) {
            SymbolGlyph(activity.icon)
              .fontSize(28)
              .fontColor([activity.color])

            Text(activity.name)
              .fontSize(13)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)

            Text(activity.description)
              .fontSize(10)
              .fontColor('#AAAAAA')
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .padding({ left: 24, right: 24 })

            if (this.miniRunning && this.currentIndex === index) {
              Text(this.formatMiniTime())
                .fontSize(18)
                .fontColor(activity.color)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 4 })
            } else {
              Button() {
                Text(`${activity.durationSeconds}s`)
                  .fontColor(Color.White)
                  .fontSize(11)
              }
              .height(32)
              .padding({ left: 16, right: 16 })
              .backgroundColor(activity.color)
              .borderRadius(16)
              .margin({ top: 4 })
              .onClick(() => {
                this.currentIndex = index
                this.startMiniTimer(activity.durationSeconds)
              })
            }
          }
          .width(SizeConstants.FULL_WIDTH_PERCENT)
          .height(SizeConstants.FULL_HEIGHT_PERCENT)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }, (activity: BreakActivity, index: number) => `${index}`)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
      .height(SizeConstants.FULL_HEIGHT_PERCENT)
      .index(this.currentIndex)
      .indicator(
        new DotIndicator()
          .color('#444444')
          .selectedColor('#FFFFFF')
          .itemWidth(4)
          .itemHeight(4)
          .selectedItemWidth(8)
          .selectedItemHeight(4)
      )
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .height(SizeConstants.FULL_HEIGHT_PERCENT)
    .justifyContent(FlexAlign.Center)
  }

  private startMiniTimer(duration: number) {
    this.miniTimer = duration
    this.miniRunning = true
    if (this.miniIntervalId !== -1) {
      clearInterval(this.miniIntervalId)
    }
    this.miniIntervalId = setInterval(() => {
      this.miniTimer--
      if (this.miniTimer <= 0) {
        clearInterval(this.miniIntervalId)
        this.miniIntervalId = -1
        this.miniRunning = false
      }
    }, 1000)
  }

  private formatMiniTime(): string {
    const m = Math.floor(this.miniTimer / 60)
    const s = this.miniTimer % 60
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
  }
}
