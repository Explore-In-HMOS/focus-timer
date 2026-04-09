import { FocusType } from '../model/FocusType'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct CycleVisualizer {
  @Prop programCycle: number[] = [0, 1, 0, 1, 0, 2] // FocusType values
  @Prop currentIndex: number = 0
  @Prop progress: number = 0 // 0-1 for current segment
  private canvasCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private focusColor: string = '#552586'
  private shortBreakColor: string = '#4CAF50'
  private longBreakColor: string = '#2196F3'

  build() {
    Column({ space: 10 }) {
      Canvas(this.canvasCtx)
        .width(144)
        .height(144)
        .onReady(() => this.drawCycle())

      // Legend
      Row({ space: 12 }) {
        this.legendItem(this.focusColor, $r('app.string.focus'))
        this.legendItem(this.shortBreakColor, $r('app.string.break'))
      }
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .height(SizeConstants.FULL_HEIGHT_PERCENT)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  legendItem(color: string, label: Resource) {
    Row({ space: 4 }) {
      Circle().width(8).height(8).fill(color)
      Text(label).fontSize(10).fontColor('#AAAAAA')
    }
  }

  private drawCycle() {
    const ctx = this.canvasCtx
    const cx = 72
    const cy = 72
    const outerR = 58
    const innerR = 40
    const total = this.programCycle.length

    ctx.clearRect(0, 0, 144, 144)

    const segmentAngle = (Math.PI * 2) / total
    const startOffset = -Math.PI / 2

    for (let i = 0; i < total; i++) {
      const focusType = this.programCycle[i] as FocusType
      const startAngle = startOffset + i * segmentAngle
      const endAngle = startAngle + segmentAngle - 0.02 // small gap

      let color: string
      switch (focusType) {
        case FocusType.focus:
          color = this.focusColor
          break
        case FocusType.shortBreak:
          color = this.shortBreakColor
          break
        case FocusType.longBreak:
          color = this.longBreakColor
          break
        default:
          color = this.focusColor
      }

      // Draw segment
      ctx.beginPath()
      ctx.arc(cx, cy, outerR, startAngle, endAngle)
      ctx.arc(cx, cy, innerR, endAngle, startAngle, true)
      ctx.closePath()

      if (i < this.currentIndex) {
        // Completed - full color
        ctx.fillStyle = color
        ctx.globalAlpha = 1.0
      } else if (i === this.currentIndex) {
        // Current - highlighted
        ctx.fillStyle = color
        ctx.globalAlpha = 1.0
        ctx.fill()

        // Progress overlay
        const progressAngle = startAngle + segmentAngle * this.progress
        ctx.beginPath()
        ctx.arc(cx, cy, outerR + 3, startAngle, progressAngle)
        ctx.arc(cx, cy, innerR - 3, progressAngle, startAngle, true)
        ctx.closePath()
        ctx.fillStyle = '#FFFFFF'
        ctx.globalAlpha = 0.2
        ctx.fill()
        ctx.globalAlpha = 1.0
        continue
      } else {
        // Upcoming - dimmed
        ctx.fillStyle = color
        ctx.globalAlpha = 0.3
      }
      ctx.fill()
      ctx.globalAlpha = 1.0
    }

    // Center text
    ctx.fillStyle = '#FFFFFF'
    ctx.font = '12vp sans-serif'
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.fillText(`${this.currentIndex + 1}/${total}`, cx, cy - 6)

    ctx.fillStyle = '#AAAAAA'
    ctx.font = '8vp sans-serif'
    const typeNames = ['Focus', 'Break', 'Break']
    ctx.fillText(typeNames[this.programCycle[this.currentIndex]] ?? 'Focus', cx, cy + 8)
  }
}
