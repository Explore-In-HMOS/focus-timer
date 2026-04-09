export interface Tag {
  id: string
  name: Resource
  icon: Resource
  color: string
}

export const TAG_COLORS: string[] = [
  '#552586', '#2196F3', '#4CAF50', '#FF9800', '#E91E63',
  '#00BCD4', '#795548', '#607D8B'
]

export const DEFAULT_TAGS: Tag[] = [
  { id: 'work', name: $r('app.string.tag_work'), icon: $r('sys.symbol.briefcase'), color: '#552586' },
  { id: 'study', name: $r('app.string.tag_study'), icon: $r('sys.symbol.list_bullet'), color: '#2196F3' },
  { id: 'coding', name: $r('app.string.tag_coding'), icon: $r('sys.symbol.bolt_fill'), color: '#4CAF50' },
  { id: 'exercise', name: $r('app.string.tag_exercise'), icon: $r('sys.symbol.figure_walk'), color: '#FF9800' },
  { id: 'reading', name: $r('app.string.tag_reading'), icon: $r('sys.symbol.clock_fill'), color: '#E91E63' },
  { id: 'meditation', name: $r('app.string.tag_meditation'), icon: $r('sys.symbol.moon_fill'), color: '#00BCD4' }
]
