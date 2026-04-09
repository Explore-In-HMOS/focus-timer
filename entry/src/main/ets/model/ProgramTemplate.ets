import { FocusType } from './FocusType'

export interface ProgramTemplate {
  id: string
  name: Resource
  description: Resource
  icon: Resource
  focusMinutes: number
  shortBreakMinutes: number
  longBreakMinutes: number
  cyclePattern: FocusType[]
}

export const PROGRAM_TEMPLATES: ProgramTemplate[] = [
  {
    id: 'pomodoro',
    name: $r('app.string.prog_pomodoro'),
    description: $r('app.string.prog_pomodoro_desc'),
    icon: $r('sys.symbol.timer'),
    focusMinutes: 25,
    shortBreakMinutes: 5,
    longBreakMinutes: 20,
    cyclePattern: [
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.longBreak
    ]
  },
  {
    id: 'deep_work',
    name: $r('app.string.prog_deep_work'),
    description: $r('app.string.prog_deep_work_desc'),
    icon: $r('sys.symbol.flame_fill'),
    focusMinutes: 90,
    shortBreakMinutes: 20,
    longBreakMinutes: 30,
    cyclePattern: [
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.longBreak
    ]
  },
  {
    id: 'sprint',
    name: $r('app.string.prog_sprint'),
    description: $r('app.string.prog_sprint_desc'),
    icon: $r('sys.symbol.forward_end_fill'),
    focusMinutes: 15,
    shortBreakMinutes: 3,
    longBreakMinutes: 10,
    cyclePattern: [
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.longBreak
    ]
  },
  {
    id: 'study',
    name: $r('app.string.prog_study'),
    description: $r('app.string.prog_study_desc'),
    icon: $r('sys.symbol.list_bullet'),
    focusMinutes: 50,
    shortBreakMinutes: 10,
    longBreakMinutes: 25,
    cyclePattern: [
      FocusType.focus, FocusType.shortBreak,
      FocusType.focus, FocusType.longBreak
    ]
  }
]
