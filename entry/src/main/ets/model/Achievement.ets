export interface Achievement {
  id: string
  name: Resource
  description: Resource
  icon: Resource
  targetValue: number
  category: AchievementCategory
}

export enum AchievementCategory {
  sessions,
  minutes,
  streak,
  exploration
}

export interface AchievementProgress {
  achievementId: string
  currentValue: number
  unlocked: boolean
  unlockedDate?: number
}

export const ACHIEVEMENTS: Achievement[] = [
  // Session milestones
  {
    id: 'first_session', name: $r('app.string.ach_first_session'), description: $r('app.string.ach_first_session_desc'),
    icon: $r('sys.symbol.star_fill'), targetValue: 1, category: AchievementCategory.sessions
  },
  {
    id: 'ten_sessions', name: $r('app.string.ach_ten_sessions'), description: $r('app.string.ach_ten_sessions_desc'),
    icon: $r('sys.symbol.flame_fill'), targetValue: 10, category: AchievementCategory.sessions
  },
  {
    id: 'fifty_sessions', name: $r('app.string.ach_fifty_sessions'), description: $r('app.string.ach_fifty_sessions_desc'),
    icon: $r('sys.symbol.bolt_fill'), targetValue: 50, category: AchievementCategory.sessions
  },
  {
    id: 'hundred_sessions', name: $r('app.string.ach_hundred_sessions'), description: $r('app.string.ach_hundred_sessions_desc'),
    icon: $r('sys.symbol.checkmark_circle_fill'), targetValue: 100, category: AchievementCategory.sessions
  },
  {
    id: 'five_hundred_sessions', name: $r('app.string.ach_five_hundred_sessions'), description: $r('app.string.ach_five_hundred_sessions_desc'),
    icon: $r('sys.symbol.star_fill'), targetValue: 500, category: AchievementCategory.sessions
  },
  // Minute milestones
  {
    id: 'hour_focus', name: $r('app.string.ach_hour_focus'), description: $r('app.string.ach_hour_focus_desc'),
    icon: $r('sys.symbol.clock_fill'), targetValue: 60, category: AchievementCategory.minutes
  },
  {
    id: 'five_hour_focus', name: $r('app.string.ach_five_hour_focus'), description: $r('app.string.ach_five_hour_focus_desc'),
    icon: $r('sys.symbol.clock_fill'), targetValue: 300, category: AchievementCategory.minutes
  },
  {
    id: 'day_focus', name: $r('app.string.ach_day_focus'), description: $r('app.string.ach_day_focus_desc'),
    icon: $r('sys.symbol.sun_max_fill'), targetValue: 1440, category: AchievementCategory.minutes
  },
  // Streak milestones
  {
    id: 'three_day_streak', name: $r('app.string.ach_three_day_streak'), description: $r('app.string.ach_three_day_streak_desc'),
    icon: $r('sys.symbol.flame'), targetValue: 3, category: AchievementCategory.streak
  },
  {
    id: 'seven_day_streak', name: $r('app.string.ach_seven_day_streak'), description: $r('app.string.ach_seven_day_streak_desc'),
    icon: $r('sys.symbol.flame_fill'), targetValue: 7, category: AchievementCategory.streak
  },
  {
    id: 'thirty_day_streak', name: $r('app.string.ach_thirty_day_streak'), description: $r('app.string.ach_thirty_day_streak_desc'),
    icon: $r('sys.symbol.heart_fill'), targetValue: 30, category: AchievementCategory.streak
  },
  // Exploration
  {
    id: 'all_tags', name: $r('app.string.ach_all_tags'), description: $r('app.string.ach_all_tags_desc'),
    icon: $r('sys.symbol.list_bullet'), targetValue: 6, category: AchievementCategory.exploration
  },
  {
    id: 'theme_changer', name: $r('app.string.ach_theme_changer'), description: $r('app.string.ach_theme_changer_desc'),
    icon: $r('sys.symbol.paintpalette_fill'), targetValue: 3, category: AchievementCategory.exploration
  },
  {
    id: 'all_programs', name: $r('app.string.ach_all_programs'), description: $r('app.string.ach_all_programs_desc'),
    icon: $r('sys.symbol.list_bullet'), targetValue: 4, category: AchievementCategory.exploration
  },
  {
    id: 'early_bird', name: $r('app.string.ach_early_bird'), description: $r('app.string.ach_early_bird_desc'),
    icon: $r('sys.symbol.sunrise_fill'), targetValue: 5, category: AchievementCategory.exploration
  }
]
