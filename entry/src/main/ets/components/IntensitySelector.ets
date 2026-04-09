import { IntensityLevel, IntensityConfig, INTENSITY_CONFIGS } from '../model/IntensityModel'

@Component
export default struct IntensitySelector {
  @Link selectedIntensity: IntensityLevel

  build() {
    Column({ space: 8 }) {
      Text($r('app.string.intensity'))
        .fontSize(12)
        .fontColor('#CCCCCC')

      Row({ space: 4 }) {
        ForEach(INTENSITY_CONFIGS, (config: IntensityConfig) => {
          Column({ space: 4 }) {
            Stack() {
              Circle()
                .width(36)
                .height(36)
                .fill(this.selectedIntensity === config.level ? config.color : '#2A2A2A')

              SymbolGlyph(config.icon)
                .fontSize(16)
                .fontColor([this.selectedIntensity === config.level ? Color.White : config.color])
            }

            Text(config.name)
              .fontSize(8)
              .fontColor(this.selectedIntensity === config.level ? Color.White : '#888888')
          }
          .onClick(() => {
            this.getUIContext()?.animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
              this.selectedIntensity = config.level
              AppStorage.setOrCreate('selectedIntensity', config.level)
            })
          })
        }, (config: IntensityConfig) => `${config.level}`)
      }
      .justifyContent(FlexAlign.Center)

      // Multiplier info
      DataPanel({ values: [this.getConfig().focusMultiplier * 50, this.getConfig().breakMultiplier * 50], max: 100 })
        .width(120)
        .height(8)
        .valueColors([this.getConfig().color, '#4CAF50'])

      Row({ space: 16 }) {
        Text(`Focus x${this.getConfig().focusMultiplier}`)
          .fontSize(8)
          .fontColor('#AAAAAA')
        Text(`Break x${this.getConfig().breakMultiplier}`)
          .fontSize(8)
          .fontColor('#AAAAAA')
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }

  private getConfig(): IntensityConfig {
    return INTENSITY_CONFIGS.find((c: IntensityConfig) => c.level === this.selectedIntensity) ?? INTENSITY_CONFIGS[1]
  }
}
