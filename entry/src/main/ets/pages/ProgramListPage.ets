import { PROGRAM_TEMPLATES, ProgramTemplate } from '../model/ProgramTemplate'
import { FocusType } from '../model/FocusType'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export struct ProgramListPage {
  @Consume('pageInfos') pageInfos: NavPathStack
  @State selectedProgramId: string = (AppStorage.get('selectedProgram') as string) ?? 'pomodoro'
  @State programs: ProgramTemplate[] = PROGRAM_TEMPLATES

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

          Text($r('app.string.programs'))
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

        // Program list
        List({ space: 8 }) {
          ForEach(this.programs, (prog: ProgramTemplate) => {
            ListItem() {
              Row({ space: 10 }) {
                Stack() {
                  Circle()
                    .width(40)
                    .height(40)
                    .fill(this.selectedProgramId === prog.id ? '#552586' : '#2A2A2A')

                  SymbolGlyph(prog.icon)
                    .fontSize(18)
                    .fontColor([this.selectedProgramId === prog.id ? Color.White : '#AAAAAA'])
                }

                Column({ space: 3 }) {
                  Text(prog.name)
                    .fontSize(12)
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Medium)

                  Text(prog.description)
                    .fontSize(9)
                    .fontColor('#888888')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  // Cycle preview dots
                  Row({ space: 3 }) {
                    ForEach(prog.cyclePattern, (type: FocusType, index: number) => {
                      Circle()
                        .width(6)
                        .height(6)
                        .fill(this.getTypeColor(type))
                    }, (_type: FocusType, index: number) => `${prog.id}_${index}`)
                  }

                  // Duration info
                  Text(`${prog.focusMinutes}m / ${prog.shortBreakMinutes}m / ${prog.longBreakMinutes}m`)
                    .fontSize(8)
                    .fontColor('#666666')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                if (this.selectedProgramId === prog.id) {
                  SymbolGlyph($r('sys.symbol.checkmark_circle_fill'))
                    .fontSize(18)
                    .fontColor(['#4CAF50'])
                }
              }
              .width(SizeConstants.FULL_WIDTH_PERCENT)
              .padding(10)
              .backgroundColor(this.selectedProgramId === prog.id ? '#1E1040' : '#1A1A1A')
              .borderRadius(12)
              .border({
                width: this.selectedProgramId === prog.id ? 1 : 0,
                color: '#552586'
              })
              .onClick(() => {
                this.getUIContext()?.animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
                  this.selectedProgramId = prog.id
                  this.applyProgram(prog)
                })
              })
            }
          }, (prog: ProgramTemplate) => prog.id)
        }
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .layoutWeight(1)
        .padding({
          left: SizeConstants.PAGE_SIDE_PADDING,
          right: SizeConstants.PAGE_SIDE_PADDING,
          bottom: SizeConstants.PAGE_CONTENT_BOTTOM_PADDING
        })
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
      .height(SizeConstants.FULL_HEIGHT_PERCENT)
      .backgroundColor('#0D0D0D')
    }
    .hideTitleBar(true)
  }

  private getTypeColor(type: FocusType): string {
    switch (type) {
      case FocusType.focus: return '#552586'
      case FocusType.shortBreak: return '#4CAF50'
      case FocusType.longBreak: return '#2196F3'
      default: return '#552586'
    }
  }

  private applyProgram(prog: ProgramTemplate) {
    AppStorage.setOrCreate('selectedProgram', prog.id)
    const times = new Map<FocusType, number>([
      [FocusType.focus, prog.focusMinutes],
      [FocusType.shortBreak, prog.shortBreakMinutes],
      [FocusType.longBreak, prog.longBreakMinutes]
    ])
    AppStorage.setOrCreate('defaultTimes', times)
    AppStorage.setOrCreate('programIndex', 0)
    // Track programs used for achievement
    const usedPrograms: string = AppStorage.get('usedProgramsList') ?? ''
    if (!usedPrograms.includes(prog.id)) {
      const updated = usedPrograms ? `${usedPrograms},${prog.id}` : prog.id
      AppStorage.setOrCreate('usedProgramsList', updated)
      AppStorage.setOrCreate('programsUsedCount', updated.split(',').length)
    }
  }
}
