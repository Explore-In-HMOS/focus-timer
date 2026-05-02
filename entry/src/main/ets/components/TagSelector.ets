import { DEFAULT_TAGS, Tag } from '../model/TagModel'
import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct TagSelector {
  @Link selectedTagId: string
  private tags: Tag[] = DEFAULT_TAGS

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.tags, (tag: Tag) => {
        Row({ space: 3 }) {
          SymbolGlyph(tag.icon)
            .fontSize(11)
            .fontColor([this.selectedTagId === tag.id ? Color.White : tag.color])

          Text(tag.name)
            .fontSize(10)
            .fontColor(this.selectedTagId === tag.id ? Color.White : '#CCCCCC')
        }
        .padding({ left: 7, right: 7, top: 3, bottom: 3 })
        .borderRadius(14)
        .backgroundColor(this.selectedTagId === tag.id ? tag.color : '#2A2A2A')
        .border({
          width: 1,
          color: this.selectedTagId === tag.id ? tag.color : '#444444'
        })
        .margin({ right: 4, bottom: 4 })
        .onClick(() => {
          this.selectedTagId = this.selectedTagId === tag.id ? '' : tag.id
        })
      }, (tag: Tag) => tag.id)
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
  }
}
