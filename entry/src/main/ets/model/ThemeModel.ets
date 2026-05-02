export interface ThemeColors {
  gradient1: string
  gradient2: string
  gradient3: string
  gradient4: string
  gradient5: string
}

export interface AppTheme {
  id: string
  name: Resource
  colors: ThemeColors
}

export const THEMES: AppTheme[] = [
  {
    id: 'purple',
    name: $r('app.string.theme_purple'),
    colors: { gradient1: '#B589D6', gradient2: '#9969C7', gradient3: '#804FB3', gradient4: '#6A359C', gradient5: '#552586' }
  },
  {
    id: 'blue',
    name: $r('app.string.theme_blue'),
    colors: { gradient1: '#64B5F6', gradient2: '#42A5F5', gradient3: '#2196F3', gradient4: '#1E88E5', gradient5: '#1565C0' }
  },
  {
    id: 'green',
    name: $r('app.string.theme_green'),
    colors: { gradient1: '#81C784', gradient2: '#66BB6A', gradient3: '#4CAF50', gradient4: '#43A047', gradient5: '#2E7D32' }
  },
  {
    id: 'red',
    name: $r('app.string.theme_red'),
    colors: { gradient1: '#E57373', gradient2: '#EF5350', gradient3: '#F44336', gradient4: '#E53935', gradient5: '#C62828' }
  },
  {
    id: 'orange',
    name: $r('app.string.theme_orange'),
    colors: { gradient1: '#FFB74D', gradient2: '#FFA726', gradient3: '#FF9800', gradient4: '#FB8C00', gradient5: '#E65100' }
  },
  {
    id: 'cyan',
    name: $r('app.string.theme_cyan'),
    colors: { gradient1: '#4DD0E1', gradient2: '#26C6DA', gradient3: '#00BCD4', gradient4: '#00ACC1', gradient5: '#00838F' }
  }
]

export function getThemeById(id: string): AppTheme {
  return THEMES.find((t: AppTheme) => t.id === id) ?? THEMES[0]
}
