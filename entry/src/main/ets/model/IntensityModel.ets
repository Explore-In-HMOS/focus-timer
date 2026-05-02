export enum IntensityLevel {
  light,
  normal,
  intense
}

export interface IntensityConfig {
  level: IntensityLevel
  name: Resource
  icon: Resource
  color: string
  focusMultiplier: number
  breakMultiplier: number
}

export const INTENSITY_CONFIGS: IntensityConfig[] = [
  {
    level: IntensityLevel.light,
    name: $r('app.string.intensity_light'),
    icon: $r('sys.symbol.leaf_fill'),
    color: '#4CAF50',
    focusMultiplier: 0.8,
    breakMultiplier: 1.2
  },
  {
    level: IntensityLevel.normal,
    name: $r('app.string.intensity_normal'),
    icon: $r('sys.symbol.circle_fill'),
    color: '#2196F3',
    focusMultiplier: 1.0,
    breakMultiplier: 1.0
  },
  {
    level: IntensityLevel.intense,
    name: $r('app.string.intensity_intense'),
    icon: $r('sys.symbol.flame_fill'),
    color: '#F44336',
    focusMultiplier: 1.2,
    breakMultiplier: 0.8
  }
]

export function getIntensityConfig(level: IntensityLevel): IntensityConfig {
  return INTENSITY_CONFIGS.find((c: IntensityConfig) => c.level === level) ?? INTENSITY_CONFIGS[1]
}
