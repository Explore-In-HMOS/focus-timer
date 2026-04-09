import { DailyGoal } from '../model/GoalModel'
import { DbService } from './DbService'

export class StreakTracker {
  private static instance: StreakTracker | null = null
  currentStreak: number = 0
  maxStreak: number = 0

  static getInstance(): StreakTracker {
    if (!StreakTracker.instance) {
      StreakTracker.instance = new StreakTracker()
    }
    return StreakTracker.instance
  }

  initialize() {
    this.currentStreak = AppStorage.get('currentStreak') ?? 0
    this.maxStreak = AppStorage.get('maxStreak') ?? 0
  }

  private save() {
    AppStorage.setOrCreate('currentStreak', this.currentStreak)
    AppStorage.setOrCreate('maxStreak', this.maxStreak)
  }

  async refresh(): Promise<void> {
    const db = DbService.getInstance()
    this.currentStreak = await db.getStreakDays()
    if (this.currentStreak > this.maxStreak) {
      this.maxStreak = this.currentStreak
    }
    this.save()
  }

  onGoalCompleted() {
    const today = DailyGoal.todayString()
    const lastGoalDate: string = AppStorage.get('lastGoalDate') ?? ''
    if (lastGoalDate !== today) {
      AppStorage.setOrCreate('lastGoalDate', today)
      this.currentStreak++
      if (this.currentStreak > this.maxStreak) {
        this.maxStreak = this.currentStreak
      }
      this.save()
    }
  }
}
