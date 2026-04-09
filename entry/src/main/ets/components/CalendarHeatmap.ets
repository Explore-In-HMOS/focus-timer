import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct CalendarHeatmap {
  @Prop dailyData: string[] = [] // "date:minutes" format
  private canvasCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private heatColors: string[] = ['#1A1A1A', '#2D1B4E', '#4A2D7A', '#6A3FA6', '#9969C7', '#B589D6']

  build() {
    Column({ space: 8 }) {
      Canvas(this.canvasCtx)
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .height(100)
        .onReady(() => this.drawHeatmap())

      // Legend row
      Row({ space: 4 }) {
        Text($r('app.string.less')).fontSize(9).fontColor('#888888')
        ForEach(this.heatColors, (color: string) => {
          Row()
            .width(10)
            .height(10)
            .borderRadius(2)
            .backgroundColor(color)
        }, (color: string) => color)
        Text($r('app.string.more')).fontSize(9).fontColor('#888888')
      }
      .justifyContent(FlexAlign.Center)
      .width(SizeConstants.FULL_WIDTH_PERCENT)
    }
    .padding({ left: 10, right: 10, top: 12, bottom: 12 })
    .width(SizeConstants.FULL_WIDTH_PERCENT)
  }

  private drawHeatmap() {
    const ctx = this.canvasCtx
    const cellSize = 10
    const gap = 2
    const cols = 14 // 2 weeks
    const rows = 7 // days of week

    // Parse data into map
    const dataMap = new Map<string, number>()
    let maxMinutes = 1
    this.dailyData.forEach((entry: string) => {
      const parts = entry.split(':')
      if (parts.length === 2) {
        const minutes = parseInt(parts[1])
        dataMap.set(parts[0], minutes)
        if (minutes > maxMinutes) maxMinutes = minutes
      }
    })

    ctx.clearRect(0, 0, 200, 100)

    // Draw cells for last 14 days x 1 row compacted into grid
    const today = new Date()
    const startDate = new Date(today)
    startDate.setDate(startDate.getDate() - (cols * rows - 1))

    for (let col = 0; col < cols; col++) {
      for (let row = 0; row < rows; row++) {
        const dayIndex = col * rows + row
        const d = new Date(startDate)
        d.setDate(d.getDate() + dayIndex)
        const dateStr = `${d.getFullYear()}-${(d.getMonth() + 1).toString().padStart(2, '0')}-${d.getDate().toString().padStart(2, '0')}`

        const minutes = dataMap.get(dateStr) ?? 0
        const intensity = Math.min(Math.floor((minutes / maxMinutes) * 5), 5)

        const x = 10 + col * (cellSize + gap)
        const y = 5 + row * (cellSize + gap)

        ctx.fillStyle = this.heatColors[intensity]
        ctx.fillRect(x, y, cellSize, cellSize)
      }
    }

    // Today marker
    const totalDays = cols * rows
    const todayIndex = totalDays - 1
    const todayCol = Math.floor(todayIndex / rows)
    const todayRow = todayIndex % rows
    const tx = 10 + todayCol * (cellSize + gap)
    const ty = 5 + todayRow * (cellSize + gap)
    ctx.strokeStyle = '#FFFFFF'
    ctx.lineWidth = 1
    ctx.strokeRect(tx, ty, cellSize, cellSize)
  }
}
