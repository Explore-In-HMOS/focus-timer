import { SizeConstants } from '../constants/SizeConstants'

@Component
export default struct QuotesProvider {
  @State private currentQuote: string = ''
  @State private currentAuthor: string = ''
  private quotes: string[][] = [
    ['The secret of getting ahead is getting started.', 'Mark Twain'],
    ['Focus on being productive instead of busy.', 'Tim Ferriss'],
    ['It is not enough to be busy. The question is: what are we busy about?', 'Thoreau'],
    ['Concentrate all your thoughts upon the work at hand.', 'Alexander Graham Bell'],
    ['Do what you can, with what you have, where you are.', 'Theodore Roosevelt'],
    ['The way to get started is to quit talking and begin doing.', 'Walt Disney'],
    ['You don\'t have to be great to start, but you have to start to be great.', 'Zig Ziglar'],
    ['Action is the foundational key to all success.', 'Pablo Picasso'],
    ['Small daily improvements are the key to staggering long-term results.', ''],
    ['Your mind is for having ideas, not holding them.', 'David Allen'],
    ['Simplicity is the ultimate sophistication.', 'Leonardo da Vinci'],
    ['Amateurs sit and wait for inspiration. The rest of us just get up and go to work.', 'Stephen King'],
    ['The only way to do great work is to love what you do.', 'Steve Jobs'],
    ['Deep work is the ability to focus without distraction on a cognitively demanding task.', 'Cal Newport'],
    ['Time is what we want most, but what we use worst.', 'William Penn'],
    ['Productivity is never an accident. It is the result of commitment to excellence.', 'Paul J. Meyer'],
  ]

  aboutToAppear() {
    this.pickRandom()
  }

  build() {
    Column({ space: 4 }) {
      Marquee({
        start: true,
        step: 3,
        loop: -1,
        fromStart: true,
        src: this.currentQuote
      })
        .width(SizeConstants.FULL_WIDTH_PERCENT)
        .fontSize(11)
        .fontColor('#CCCCCC')

      if (this.currentAuthor !== '') {
        Text(`— ${this.currentAuthor}`)
          .fontSize(10)
          .fontColor('#888888')
          .fontStyle(FontStyle.Italic)
      }
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
  }

  private pickRandom() {
    const index = Math.floor(Math.random() * this.quotes.length)
    this.currentQuote = this.quotes[index][0]
    this.currentAuthor = this.quotes[index][1]
  }
}
