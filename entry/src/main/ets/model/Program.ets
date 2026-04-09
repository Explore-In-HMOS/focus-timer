import Focus from './Focus'
import { FocusType } from './FocusType'

@Observed
export default class Program {
  focusTimes: Map<FocusType, number> = AppStorage.get('defaultTimes') ?? defaultFocus
  readonly program: FocusType[] = [
    FocusType.focus,
    FocusType.shortBreak,
    FocusType.focus,
    FocusType.shortBreak,
    FocusType.focus,
    FocusType.longBreak
  ]
  private programIndex: number = AppStorage.get('programIndex') ?? 0
  currentFocus = this.getCurrentFocus()

  getProgramIndex(): number {
    return this.programIndex
  }

  getCurrentFocus() {
    const currentType = this.program[this.programIndex]
    const currentFocus: Focus = {
      type: currentType,
      value: this.focusTimes.get(currentType)!
    }
    return currentFocus
  }

  getFocusList() {
    const focusList: Focus[] = []
    this.focusTimes.forEach((value: number, type: FocusType) => {
      focusList.push({ type: type, value: value })
    })
    return focusList
  }

  skip() {
    this.programIndex = (this.programIndex + 1) % this.program.length
    this.currentFocus = this.getCurrentFocus()
    this.setProgramIndex(this.programIndex)
  }

  changeDefaultTime(type: FocusType, val: number) {
    // Replace the map reference so @Observed notices the change.
    const updated = new Map<FocusType, number>(this.focusTimes)
    updated.set(type, val)
    this.focusTimes = updated
    AppStorage.setOrCreate('defaultTimes', updated)
    // Keep currentFocus in sync if the edited type is the one on screen.
    if (this.program[this.programIndex] === type) {
      this.currentFocus = this.getCurrentFocus()
    }
  }

  setProgramIndex(index: number) {
    AppStorage.setOrCreate('programIndex', index)
  }
}

const defaultFocus = new Map<FocusType, number>([
  [FocusType.focus, 25],
  [FocusType.shortBreak, 5],
  [FocusType.longBreak, 20]
])