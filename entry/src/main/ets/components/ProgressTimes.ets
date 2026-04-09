import { CounterComponent, CounterType } from '@ohos.arkui.advanced.Counter';
import Program from '../model/Program';
import Focus from '../model/Focus';
import { focusName } from '../model/FocusType';
import { SizeConstants } from '../constants/SizeConstants';

@Component
export default struct ProgressTimes {
  @ObjectLink program: Program;
  onTimesChanged: () => void = () => {}
  private focuses = this.program.getFocusList()

  build() {
    Column() {
      List({ space: 6 }) {
        ForEach(this.focuses, (focus: Focus) => {
          ListItem() {
            Column({ space: 4 }) {
              Text(focusName(focus.type, true))
                .fontSize(11)
                .fontColor('#CCCCCC')
              CounterComponent({
                options: {
                  type: CounterType.COMPACT,
                  numberOptions: {
                    value: focus.value,
                    min: 5,
                    max: 30,
                    textWidth: 30,
                    focusable: false,
                    onChange: (val: number) => {
                      this.program.changeDefaultTime(focus.type, val)
                      focus.value = val
                      this.onTimesChanged()
                    }
                  }
                }
              })
            }
            .width(SizeConstants.FULL_WIDTH_PERCENT)
            .padding({ top: 4, bottom: 4 })
          }
        }, (item: Focus, index: number) => `${JSON.stringify(item)}`)
      }
      .width(SizeConstants.FULL_WIDTH_PERCENT)
      .layoutWeight(1)
      .padding({
        top: SizeConstants.PAGE_HEADER_TOP_PADDING,
        bottom: SizeConstants.PAGE_CONTENT_BOTTOM_PADDING,
        left: SizeConstants.PAGE_SIDE_PADDING,
        right: SizeConstants.PAGE_SIDE_PADDING
      })
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .height(SizeConstants.FULL_HEIGHT_PERCENT)
  }
}
