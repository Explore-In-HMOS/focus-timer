import { SizeConstants } from '../constants/SizeConstants'

interface ChartSegment {
  tag: string
  value: number
}

@Component
export default struct StatsChart {
  @Prop weeklyData: number[] = [0, 0, 0, 0, 0, 0, 0]
  @Prop tagData: string[] = [] // "tag:minutes" format
  private canvasController: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private pieController: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private dayLabels: string[] = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  private chartColors: string[] = ['#552586', '#2196F3', '#4CAF50', '#FF9800', '#E91E63', '#00BCD4', '#795548', '#607D8B']

  build() {
    Column({ space: 10 }) {
      Canvas(this.canvasController)
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .height(120)
        .onReady(() => this.drawBarChart())

      Divider().color('#262626').margin({ top: 2, bottom: 2 })

      // Tag distribution pie chart
      Text($r('app.string.tag_distribution'))
        .fontSize(10)
        .fontColor('#888888')
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .padding({ left: 4 })

      Canvas(this.pieController)
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .height(120)
        .onReady(() => this.drawPieChart())
    }
    .padding({ left: 10, right: 10, top: 12, bottom: 12 })
    .width(SizeConstants.FULL_WIDTH_PERCENT)
  }

  private drawBarChart() {
    const ctx = this.canvasController
    const w = 180
    const h = 110
    const maxVal = Math.max(...this.weeklyData, 1)
    const barWidth = (w - 40) / 7
    const barGap = 2

    ctx.clearRect(0, 0, w, h)

    // Y-axis
    ctx.strokeStyle = '#555555'
    ctx.lineWidth = 0.5
    ctx.beginPath()
    ctx.moveTo(30, 5)
    ctx.lineTo(30, h - 20)
    ctx.lineTo(w - 5, h - 20)
    ctx.stroke()

    // Y-axis labels
    ctx.fillStyle = '#888888'
    ctx.font = '8vp sans-serif'
    ctx.textAlign = 'right'
    const steps = 3
    for (let i = 0; i <= steps; i++) {
      const val = Math.round((maxVal / steps) * i)
      const y = (h - 20) - ((h - 30) / steps) * i
      ctx.fillText(`${val}`, 28, y + 3)
      if (i > 0) {
        ctx.strokeStyle = '#333333'
        ctx.beginPath()
        ctx.moveTo(30, y)
        ctx.lineTo(w - 5, y)
        ctx.stroke()
      }
    }

    // Bars
    for (let i = 0; i < 7; i++) {
      const barHeight = (this.weeklyData[i] / maxVal) * (h - 30)
      const x = 32 + i * barWidth + barGap
      const y = (h - 20) - barHeight

      // Gradient bar
      const gradient = ctx.createLinearGradient(x, y, x, h - 20)
      gradient.addColorStop(0, '#9969C7')
      gradient.addColorStop(1, '#552586')
      ctx.fillStyle = gradient
      ctx.fillRect(x, y, barWidth - barGap * 2, barHeight)

      // Day label
      ctx.fillStyle = '#AAAAAA'
      ctx.font = '7vp sans-serif'
      ctx.textAlign = 'center'
      ctx.fillText(this.dayLabels[i], x + (barWidth - barGap * 2) / 2, h - 8)
    }
  }

  private drawPieChart() {
    const ctx = this.pieController
    const centerX = 60
    const centerY = 55
    const radius = 40

    ctx.clearRect(0, 0, 200, 120)

    if (this.tagData.length === 0) {
      ctx.fillStyle = '#555555'
      ctx.font = '10vp sans-serif'
      ctx.textAlign = 'center'
      ctx.fillText('No data', centerX, centerY)
      return
    }

    // Parse tag data
    let total = 0
    const segments: ChartSegment[] = []
    this.tagData.forEach((entry: string) => {
      const parts = entry.split(':')
      if (parts.length === 2) {
        const val = parseInt(parts[1])
        segments.push({ tag: parts[0], value: val })
        total += val
      }
    })

    // Draw pie slices
    let currentAngle = -Math.PI / 2
    segments.forEach((seg: ChartSegment, i: number) => {
      const sliceAngle = (seg.value / total) * 2 * Math.PI
      ctx.beginPath()
      ctx.moveTo(centerX, centerY)
      ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle)
      ctx.closePath()
      ctx.fillStyle = this.chartColors[i % this.chartColors.length]
      ctx.fill()

      currentAngle += sliceAngle
    })

    // Inner circle for donut effect
    ctx.beginPath()
    ctx.arc(centerX, centerY, radius * 0.5, 0, Math.PI * 2)
    ctx.fillStyle = '#1A1A1A'
    ctx.fill()

    // Legend
    const legendX = 115
    segments.forEach((seg: ChartSegment, i: number) => {
      const y = 15 + i * 16
      ctx.fillStyle = this.chartColors[i % this.chartColors.length]
      ctx.fillRect(legendX, y - 6, 8, 8)
      ctx.fillStyle = '#CCCCCC'
      ctx.font = '8vp sans-serif'
      ctx.textAlign = 'left'
      const pct = Math.round((seg.value / total) * 100)
      ctx.fillText(`${seg.tag} ${pct}%`, legendX + 12, y + 1)
    })
  }
}
