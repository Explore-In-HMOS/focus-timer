import { ACHIEVEMENTS, Achievement, AchievementProgress } from '../model/Achievement'
import { AchievementService } from '../service/AchievementService'
import BadgeCard from '../components/BadgeCard'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export struct AchievementsPage {
  @Consume('pageInfos') pageInfos: NavPathStack
  @State progressList: AchievementProgress[] = []
  @State unlockedCount: number = 0

  aboutToAppear() {
    const service = AchievementService.getInstance()
    this.progressList = service.getAllProgress()
    this.unlockedCount = service.getUnlockedCount()
  }

  build() {
    NavDestination() {
      Column() {
        // Header
        Row() {
          Button() {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontColor([Color.White])
              .fontSize(16)
          }
          .width(SizeConstants.HEADER_BUTTON_SIZE)
          .height(SizeConstants.HEADER_BUTTON_SIZE)
          .borderRadius(SizeConstants.HEADER_BUTTON_RADIUS)
          .backgroundColor('#333333')
          .onClick(() => this.pageInfos.pop())

          Text($r('app.string.achievements'))
            .fontSize(15)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Blank().width(SizeConstants.HEADER_BUTTON_SIZE)
        }
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .padding({
          left: SizeConstants.PAGE_SIDE_PADDING,
          right: SizeConstants.PAGE_SIDE_PADDING,
          top: SizeConstants.PAGE_HEADER_TOP_PADDING,
          bottom: 6
        })

        Scroll() {
          Column() {
            // Progress summary
            Row({ space: 8 }) {
              Text(`${this.unlockedCount}`)
                .fontSize(22)
                .fontColor('#FFD700')
                .fontWeight(FontWeight.Bold)
              Text('/')
                .fontSize(16)
                .fontColor('#666666')
              Text(`${ACHIEVEMENTS.length}`)
                .fontSize(16)
                .fontColor('#888888')
            }
            .margin({ top: 4, bottom: 4 })
            .justifyContent(FlexAlign.Center)
            .width(SizeConstants.FULL_WIDTH_PERCENT)

            Row() {
              Progress({ value: this.unlockedCount, total: ACHIEVEMENTS.length })
                .width('80%')
                .height(4)
                .color('#FFD700')
                .backgroundColor('#333333')
            }
            .width(SizeConstants.FULL_WIDTH_PERCENT)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 12 })

            Grid() {
              ForEach(ACHIEVEMENTS, (achievement: Achievement, index: number) => {
                GridItem() {
                  BadgeCard({
                    achievement: achievement,
                    progress: this.progressList[index] ?? {
                      achievementId: achievement.id,
                      currentValue: 0,
                      unlocked: false
                    }
                  })
                }
              }, (achievement: Achievement) => achievement.id)
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(8)
            .columnsGap(4)
            .width(SizeConstants.FULL_WIDTH_PERCENT)

            Blank().height(SizeConstants.PAGE_CONTENT_BOTTOM_PADDING)
          }
          .padding({
            left: SizeConstants.PAGE_SIDE_PADDING,
            right: SizeConstants.PAGE_SIDE_PADDING
          })
        }
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
      .height(SizeConstants.FULL_HEIGHT_PERCENT)
      .backgroundColor('#0D0D0D')
    }
    .hideTitleBar(true)
  }
}
