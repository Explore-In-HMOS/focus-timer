import { FocusType } from './FocusType'

export default interface SessionRecord {
  id?: number
  startTime: number
  endTime: number
  duration: number
  focusType: FocusType
  tag: string
  completed: boolean
}
