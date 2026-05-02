import { SizeConstants } from '../constants/SizeConstants'
import ThemePickerView from '../components/ThemePickerView'

@Component
export struct OnboardingPage {
  @Consume('pageInfos') pageInfos: NavPathStack
  @State private currentStep: number = 0
  @State private selectedTheme: string = 'purple'
  @State private dailyGoal: number = 120
  @State private fadeIn: number = 0

  aboutToAppear() {
    this.getUIContext()?.animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
      this.fadeIn = 1
    })
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Row({ space: 6 }) {
          ForEach([0, 1, 2, 3], (step: number) => {
            Circle()
              .width(this.currentStep === step ? 10 : 6)
              .height(6)
              .fill(this.currentStep === step ? '#552586' : '#333333')
          }, (step: number) => `${step}`)
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: SizeConstants.PAGE_HEADER_TOP_PADDING })

        Scroll() {
          Column() {
            if (this.currentStep === 0) {
              this.welcomeStep()
            } else if (this.currentStep === 1) {
              this.howItWorksStep()
            } else if (this.currentStep === 2) {
              this.goalStep()
            } else {
              this.themeStep()
            }
          }
          .width(SizeConstants.FULL_WIDTH_PERCENT)
        }
        .layoutWeight(1)
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)

        Row({ space: 8 }) {
          if (this.currentStep > 0) {
            Button() {
              Text('Back')
                .fontColor('#CCCCCC')
                .fontSize(11)
            }
            .layoutWeight(1)
            .height(36)
            .backgroundColor('#222222')
            .borderRadius(18)
            .onClick(() => {
              this.changeStep(this.currentStep - 1)
            })
          }

          Button() {
            Text(this.currentStep === 3 ? $r('app.string.get_started') : $r('app.string.next'))
              .fontColor(Color.White)
              .fontSize(11)
          }
          .layoutWeight(1)
          .height(36)
          .backgroundColor('#552586')
          .borderRadius(18)
          .onClick(() => {
            if (this.currentStep === 3) {
              this.completeOnboarding()
            } else {
              this.changeStep(this.currentStep + 1)
            }
          })
        }
        .padding({
          left: SizeConstants.PAGE_SIDE_PADDING + 8,
          right: SizeConstants.PAGE_SIDE_PADDING + 8,
          bottom: SizeConstants.PAGE_CONTENT_BOTTOM_PADDING - 16
        })
        .width(SizeConstants.FULL_WIDTH_PERCENT)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
      .height(SizeConstants.FULL_HEIGHT_PERCENT)
      .backgroundColor('#0D0D0D')
    }
    .hideTitleBar(true)
  }

  @Builder
  welcomeStep() {
    Column({ space: 12 }) {
      SymbolGlyph($r('sys.symbol.timer'))
        .fontSize(40)
        .fontColor(['#552586'])

      Text($r('app.string.onboarding_welcome'))
        .fontSize(16)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      Text($r('app.string.onboarding_welcome_desc'))
        .fontSize(11)
        .fontColor('#AAAAAA')
        .textAlign(TextAlign.Center)
        .padding({ left: 16, right: 16 })
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Center)
    .opacity(this.fadeIn)
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
  }

  @Builder
  howItWorksStep() {
    Column({ space: 8 }) {
      Text($r('app.string.onboarding_how_title'))
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      this.stepItem('1', $r('app.string.onboarding_step1'), '#552586')
      this.stepItem('2', $r('app.string.onboarding_step2'), '#4CAF50')
      this.stepItem('3', $r('app.string.onboarding_step3'), '#2196F3')
      this.stepItem('4', $r('app.string.onboarding_step4'), '#FF9800')
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .padding(16)
  }

  @Builder
  goalStep() {
    Column({ space: 12 }) {
      SymbolGlyph($r('sys.symbol.clock_fill'))
        .fontSize(32)
        .fontColor(['#FF9800'])

      Text($r('app.string.onboarding_goal_title'))
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      Text(`${this.dailyGoal} min`)
        .fontSize(28)
        .fontColor('#FF9800')
        .fontWeight(FontWeight.Bold)

      Slider({
        value: this.dailyGoal,
        min: 30,
        max: 300,
        step: 15,
        style: SliderStyle.InSet
      })
        .width('80%')
        .trackColor('#333333')
        .selectedColor('#552586')
        .blockColor('#FFFFFF')
        .onChange((value: number) => {
          this.dailyGoal = value
        })

      Row({ space: 20 }) {
        Text('30m').fontSize(9).fontColor('#888888')
        Text('5h').fontSize(9).fontColor('#888888')
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
  }

  @Builder
  themeStep() {
    Column({ space: 12 }) {
      Text($r('app.string.onboarding_theme_title'))
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      ThemePickerView({ selectedThemeId: this.selectedTheme })
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
  }

  @Builder
  stepItem(num: string, text: Resource, color: string) {
    Row({ space: 8 }) {
      Stack() {
        Circle().width(24).height(24).fill(color)
        Text(num)
          .fontSize(12)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      }

      Text(text)
        .fontSize(10)
        .fontColor('#CCCCCC')
        .layoutWeight(1)
    }
    .width('100%')
    .padding(4)
  }

  private changeStep(index: number) {
    this.getUIContext()?.animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
      this.currentStep = index
    })
  }

  private completeOnboarding() {
    AppStorage.setOrCreate('onboardingComplete', true)
    AppStorage.setOrCreate('dailyGoalTarget', this.dailyGoal)
    AppStorage.setOrCreate('selectedTheme', this.selectedTheme)
    this.pageInfos.clear()
    this.pageInfos.pushPathByName('Index', null)
  }
}
