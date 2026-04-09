import { ACHIEVEMENTS, Achievement, AchievementProgress, AchievementCategory } from '../model/Achievement'
import { DbService } from './DbService'

export class AchievementService {
  private static instance: AchievementService | null = null
  private progressMap: Map<string, AchievementProgress> = new Map()

  static getInstance(): AchievementService {
    if (!AchievementService.instance) {
      AchievementService.instance = new AchievementService()
    }
    return AchievementService.instance
  }

  initialize() {
    const saved: string | undefined = AppStorage.get('achievementProgress')
    if (saved) {
      try {
        const entries: AchievementProgress[] = JSON.parse(saved) as AchievementProgress[]
        entries.forEach((p: AchievementProgress) => {
          this.progressMap.set(p.achievementId, p)
        })
      } catch (_e) {
        // ignore parse errors
      }
    }
  }

  private save() {
    const entries: AchievementProgress[] = []
    this.progressMap.forEach((v: AchievementProgress) => entries.push(v))
    AppStorage.setOrCreate('achievementProgress', JSON.stringify(entries))
  }

  getProgress(achievementId: string): AchievementProgress {
    return this.progressMap.get(achievementId) ?? {
      achievementId: achievementId,
      currentValue: 0,
      unlocked: false
    }
  }

  getAllProgress(): AchievementProgress[] {
    const result: AchievementProgress[] = []
    ACHIEVEMENTS.forEach((a: Achievement) => {
      result.push(this.getProgress(a.id))
    })
    return result
  }

  getUnlockedCount(): number {
    let count = 0
    this.progressMap.forEach((p: AchievementProgress) => {
      if (p.unlocked) count++
    })
    return count
  }

  async checkAndUpdate(): Promise<string[]> {
    const db = DbService.getInstance()
    const newlyUnlocked: string[] = []

    const totalSessions = await db.getTotalSessionCount()
    const totalMinutes = await db.getTotalFocusMinutes()
    const streak = await db.getStreakDays()
    const tagCount = await db.getDistinctTagCount()
    const themesUsed: number = AppStorage.get('themesUsedCount') ?? 1
    const programsUsed: number = AppStorage.get('programsUsedCount') ?? 1
    const earlyBirdCount: number = AppStorage.get('earlyBirdCount') ?? 0

    for (const achievement of ACHIEVEMENTS) {
      let currentValue = 0
      switch (achievement.category) {
        case AchievementCategory.sessions:
          currentValue = totalSessions
          break
        case AchievementCategory.minutes:
          currentValue = totalMinutes
          break
        case AchievementCategory.streak:
          currentValue = streak
          break
        case AchievementCategory.exploration:
          if (achievement.id === 'all_tags') currentValue = tagCount
          else if (achievement.id === 'theme_changer') currentValue = themesUsed
          else if (achievement.id === 'all_programs') currentValue = programsUsed
          else if (achievement.id === 'early_bird') currentValue = earlyBirdCount
          break
      }

      const existing = this.getProgress(achievement.id)
      const wasUnlocked = existing.unlocked
      const isNowUnlocked = currentValue >= achievement.targetValue

      const updated: AchievementProgress = {
        achievementId: achievement.id,
        currentValue: currentValue,
        unlocked: isNowUnlocked,
        unlockedDate: isNowUnlocked && !wasUnlocked ? Date.now() : existing.unlockedDate
      }
      this.progressMap.set(achievement.id, updated)

      if (isNowUnlocked && !wasUnlocked) {
        newlyUnlocked.push(achievement.id)
      }
    }

    this.save()
    return newlyUnlocked
  }
}
