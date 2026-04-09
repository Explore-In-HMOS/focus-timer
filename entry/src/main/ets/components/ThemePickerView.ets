import { AppTheme, THEMES } from '../model/ThemeModel'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct ThemePickerView {
  @Link selectedThemeId: string

  build() {
    Column({ space: 8 }) {
      Text($r('app.string.select_theme'))
        .fontSize(12)
        .fontColor('#CCCCCC')

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
        ForEach(THEMES, (theme: AppTheme) => {
          Column({ space: 4 }) {
            Stack() {
              Circle()
                .width(36)
                .height(36)
                .fill(theme.colors.gradient5)

              Circle()
                .width(24)
                .height(24)
                .fill(theme.colors.gradient3)

              Circle()
                .width(12)
                .height(12)
                .fill(theme.colors.gradient1)

              if (this.selectedThemeId === theme.id) {
                Circle()
                  .width(40)
                  .height(40)
                  .fill(Color.Transparent)
                  .stroke(Color.White)
                  .strokeWidth(2)
              }
            }

            Text(theme.name)
              .fontSize(8)
              .fontColor(this.selectedThemeId === theme.id ? Color.White : '#888888')
              .textAlign(TextAlign.Center)
          }
          .margin({ right: 8, bottom: 8 })
          .onClick(() => {
            this.selectedThemeId = theme.id
            AppStorage.setOrCreate('selectedTheme', theme.id)
            // Track themes used for achievement
            const usedThemes: string = AppStorage.get('usedThemesList') ?? ''
            if (!usedThemes.includes(theme.id)) {
              const updated = usedThemes ? `${usedThemes},${theme.id}` : theme.id
              AppStorage.setOrCreate('usedThemesList', updated)
              AppStorage.setOrCreate('themesUsedCount', updated.split(',').length)
            }
          })
        }, (theme: AppTheme) => theme.id)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
    }
  }
}
