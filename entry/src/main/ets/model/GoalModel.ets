@Observed
export class DailyGoal {
  targetMinutes: number
  completedMinutes: number
  date: string

  constructor(targetMinutes: number = 120, completedMinutes: number = 0) {
    this.targetMinutes = targetMinutes
    this.completedMinutes = completedMinutes
    this.date = DailyGoal.todayString()
  }

  get progress(): number {
    if (this.targetMinutes <= 0) return 0
    return Math.min(this.completedMinutes / this.targetMinutes, 1.0)
  }

  get isCompleted(): boolean {
    return this.completedMinutes >= this.targetMinutes
  }

  get remainingMinutes(): number {
    return Math.max(this.targetMinutes - this.completedMinutes, 0)
  }

  addMinutes(minutes: number) {
    this.completedMinutes += minutes
  }

  static todayString(): string {
    const now = new Date()
    return `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2, '0')}-${now.getDate().toString().padStart(2, '0')}`
  }

  resetIfNewDay() {
    const today = DailyGoal.todayString()
    if (this.date !== today) {
      this.completedMinutes = 0
      this.date = today
    }
  }
}
