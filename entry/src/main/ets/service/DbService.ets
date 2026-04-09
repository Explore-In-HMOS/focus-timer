import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { BusinessError } from '@kit.BasicServicesKit'
import SessionRecord from '../model/SessionRecord'
import { FocusType } from '../model/FocusType'

const TAG = 'DbService'
const DB_NAME = 'FocusTimer.db'

const CREATE_SESSIONS_TABLE = `CREATE TABLE IF NOT EXISTS sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start_time INTEGER NOT NULL,
  end_time INTEGER NOT NULL,
  duration INTEGER NOT NULL,
  focus_type INTEGER NOT NULL,
  tag TEXT NOT NULL DEFAULT '',
  completed INTEGER NOT NULL DEFAULT 1
)`

const CREATE_DAILY_STATS_TABLE = `CREATE TABLE IF NOT EXISTS daily_stats (
  date TEXT PRIMARY KEY,
  total_minutes INTEGER NOT NULL DEFAULT 0,
  session_count INTEGER NOT NULL DEFAULT 0,
  goal_met INTEGER NOT NULL DEFAULT 0
)`

export class DbService {
  private rdbStore: relationalStore.RdbStore | null = null
  private static instance: DbService | null = null

  static getInstance(): DbService {
    if (!DbService.instance) {
      DbService.instance = new DbService()
    }
    return DbService.instance
  }

  async initialize(context: Context): Promise<void> {
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    try {
      this.rdbStore = await relationalStore.getRdbStore(context, config)
      await this.rdbStore.executeSql(CREATE_SESSIONS_TABLE)
      await this.rdbStore.executeSql(CREATE_DAILY_STATS_TABLE)
      hilog.info(0x0000, TAG, 'Database initialized successfully')
    } catch (err) {
      this.logError('Failed to initialize database', err)
    }
  }

  async insertSession(record: SessionRecord): Promise<number> {
    if (!this.rdbStore) return -1

    const bucket: ValuesBucket = {
      'start_time': record.startTime,
      'end_time': record.endTime,
      'duration': record.duration,
      'focus_type': record.focusType as number,
      'tag': record.tag,
      'completed': record.completed ? 1 : 0
    }

    try {
      const rowId = await this.rdbStore.insert('sessions', bucket)
      hilog.info(0x0000, TAG, 'Session inserted with id: %{public}d', rowId)
      await this.updateDailyStats(record)
      return rowId
    } catch (err) {
      this.logError('Failed to insert session', err)
      return -1
    }
  }

  private async updateDailyStats(record: SessionRecord): Promise<void> {
    if (!this.rdbStore) return

    const date = this.getDateString(record.startTime)
    const minutes = Math.floor(record.duration / 60)

    try {
      const predicates = new relationalStore.RdbPredicates('daily_stats')
      predicates.equalTo('date', date)

      const result = await this.rdbStore.query(predicates, ['date', 'total_minutes', 'session_count'])
      if (result.goToFirstRow()) {
        const currentMinutes = result.getLong(result.getColumnIndex('total_minutes'))
        const currentCount = result.getLong(result.getColumnIndex('session_count'))
        const bucket: ValuesBucket = {
          'total_minutes': currentMinutes + minutes,
          'session_count': currentCount + 1
        }
        result.close()
        await this.rdbStore.update(bucket, predicates)
      } else {
        result.close()
        const bucket: ValuesBucket = {
          'date': date,
          'total_minutes': minutes,
          'session_count': 1,
          'goal_met': 0
        }
        await this.rdbStore.insert('daily_stats', bucket)
      }
    } catch (err) {
      this.logError('Failed to update daily stats', err)
    }
  }

  async markGoalMet(date: string): Promise<void> {
    if (!this.rdbStore) return

    try {
      const predicates = new relationalStore.RdbPredicates('daily_stats')
      predicates.equalTo('date', date)
      const bucket: ValuesBucket = { 'goal_met': 1 }
      await this.rdbStore.update(bucket, predicates)
    } catch (err) {
      this.logError('Failed to mark goal as met', err)
    }
  }

  async getSessionsForDate(date: string): Promise<SessionRecord[]> {
    if (!this.rdbStore) return []

    try {
      const dayStart = new Date(date).getTime()
      const dayEnd = dayStart + 86400000
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.greaterThanOrEqualTo('start_time', dayStart)
      predicates.lessThan('start_time', dayEnd)
      predicates.orderByDesc('start_time')
      return await this.querySessionsWithPredicates(predicates)
    } catch (err) {
      this.logError('Failed to get sessions for date', err)
      return []
    }
  }

  async getRecentSessions(limit: number = 50): Promise<SessionRecord[]> {
    if (!this.rdbStore) return []

    try {
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.orderByDesc('start_time')
      predicates.limitAs(limit)
      return await this.querySessionsWithPredicates(predicates)
    } catch (err) {
      this.logError('Failed to get recent sessions', err)
      return []
    }
  }

  async getTotalSessionCount(): Promise<number> {
    if (!this.rdbStore) return 0

    try {
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.equalTo('completed', 1)
      const result = await this.rdbStore.query(predicates, ['id'])
      const count = result.rowCount
      result.close()
      return count
    } catch (err) {
      this.logError('Failed to get total session count', err)
      return 0
    }
  }

  async getTotalFocusMinutes(): Promise<number> {
    if (!this.rdbStore) return 0

    try {
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.equalTo('completed', 1)
      predicates.equalTo('focus_type', FocusType.focus as number)
      const result = await this.rdbStore.query(predicates, ['duration'])
      let total = 0
      while (result.goToNextRow()) {
        total += result.getLong(result.getColumnIndex('duration'))
      }
      result.close()
      return Math.floor(total / 60)
    } catch (err) {
      this.logError('Failed to get total focus minutes', err)
      return 0
    }
  }

  async getDailyStatsForRange(startDate: string, endDate: string): Promise<Map<string, number>> {
    if (!this.rdbStore) return new Map()

    try {
      const predicates = new relationalStore.RdbPredicates('daily_stats')
      predicates.greaterThanOrEqualTo('date', startDate)
      predicates.lessThanOrEqualTo('date', endDate)
      predicates.orderByAsc('date')
      const result = await this.rdbStore.query(predicates, ['date', 'total_minutes'])
      const stats = new Map<string, number>()
      while (result.goToNextRow()) {
        const date = result.getString(result.getColumnIndex('date'))
        const minutes = result.getLong(result.getColumnIndex('total_minutes'))
        stats.set(date, minutes)
      }
      result.close()
      return stats
    } catch (err) {
      this.logError('Failed to get daily stats for range', err)
      return new Map()
    }
  }

  async getTagDistribution(): Promise<Map<string, number>> {
    if (!this.rdbStore) return new Map()

    try {
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.equalTo('completed', 1)
      predicates.notEqualTo('tag', '')
      const result = await this.rdbStore.query(predicates, ['tag', 'duration'])
      const distribution = new Map<string, number>()
      while (result.goToNextRow()) {
        const tag = result.getString(result.getColumnIndex('tag'))
        const duration = result.getLong(result.getColumnIndex('duration'))
        const current = distribution.get(tag) ?? 0
        distribution.set(tag, current + Math.floor(duration / 60))
      }
      result.close()
      return distribution
    } catch (err) {
      this.logError('Failed to get tag distribution', err)
      return new Map()
    }
  }

  async getStreakDays(): Promise<number> {
    if (!this.rdbStore) return 0

    try {
      const predicates = new relationalStore.RdbPredicates('daily_stats')
      predicates.greaterThan('session_count', 0)
      predicates.orderByDesc('date')
      const result = await this.rdbStore.query(predicates, ['date'])
      let streak = 0
      let expectedDate = new Date()
      while (result.goToNextRow()) {
        const dateStr = result.getString(result.getColumnIndex('date'))
        const expected = this.getDateString(expectedDate.getTime())
        if (dateStr === expected) {
          streak++
          expectedDate.setDate(expectedDate.getDate() - 1)
        } else {
          break
        }
      }
      result.close()
      return streak
    } catch (err) {
      this.logError('Failed to get streak days', err)
      return 0
    }
  }

  async getDistinctTagCount(): Promise<number> {
    if (!this.rdbStore) return 0

    try {
      const predicates = new relationalStore.RdbPredicates('sessions')
      predicates.notEqualTo('tag', '')
      predicates.distinct()
      const result = await this.rdbStore.query(predicates, ['tag'])
      const tags = new Set<string>()
      while (result.goToNextRow()) {
        tags.add(result.getString(result.getColumnIndex('tag')))
      }
      result.close()
      return tags.size
    } catch (err) {
      this.logError('Failed to get distinct tag count', err)
      return 0
    }
  }

  async getWeeklyStats(): Promise<number[]> {
    if (!this.rdbStore) return []

    const stats: number[] = []

    try {
      const today = new Date()
      for (let i = 6; i >= 0; i--) {
        const d = new Date(today)
        d.setDate(d.getDate() - i)
        const dateStr = this.getDateString(d.getTime())
        const predicates = new relationalStore.RdbPredicates('daily_stats')
        predicates.equalTo('date', dateStr)

        const result = await this.rdbStore.query(predicates, ['total_minutes'])
        if (result.goToFirstRow()) {
          stats.push(result.getLong(result.getColumnIndex('total_minutes')))
        } else {
          stats.push(0)
        }
        result.close()
      }
      return stats
    } catch (err) {
      this.logError('Failed to get weekly stats', err)
      return stats
    }
  }

  private async querySessionsWithPredicates(predicates: relationalStore.RdbPredicates): Promise<SessionRecord[]> {
    if (!this.rdbStore) return []

    try {
      const result = await this.rdbStore.query(predicates,
        ['id', 'start_time', 'end_time', 'duration', 'focus_type', 'tag', 'completed'])
      const sessions: SessionRecord[] = []
      while (result.goToNextRow()) {
        sessions.push({
          id: result.getLong(result.getColumnIndex('id')),
          startTime: result.getLong(result.getColumnIndex('start_time')),
          endTime: result.getLong(result.getColumnIndex('end_time')),
          duration: result.getLong(result.getColumnIndex('duration')),
          focusType: result.getLong(result.getColumnIndex('focus_type')) as FocusType,
          tag: result.getString(result.getColumnIndex('tag')),
          completed: result.getLong(result.getColumnIndex('completed')) === 1
        })
      }
      result.close()
      return sessions
    } catch (err) {
      this.logError('Failed to query sessions', err)
      return []
    }
  }

  private getDateString(timestamp: number): string {
    const d = new Date(timestamp)
    return `${d.getFullYear()}-${(d.getMonth() + 1).toString().padStart(2, '0')}-${d.getDate().toString().padStart(2, '0')}`
  }

  private logError(message: string, err: BusinessError): void {
    const error = err
    hilog.error(0x0000, TAG, `${message}: %{public}s`, error.message)
  }
}
