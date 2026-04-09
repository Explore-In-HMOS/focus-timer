import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbService } from '../service/DbService';
import { AchievementService } from '../service/AchievementService';
import { StreakTracker } from '../service/StreakTracker';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // Initialize persistent storage
    PersistentStorage.persistProp('defaultTimes', null)
    PersistentStorage.persistProp('programIndex', null)
    PersistentStorage.persistProp('onboardingComplete', false)
    PersistentStorage.persistProp('selectedTheme', 'purple')
    PersistentStorage.persistProp('selectedIntensity', 1)
    PersistentStorage.persistProp('dailyGoalTarget', 120)
    PersistentStorage.persistProp('dailyGoalCompleted', 0)
    PersistentStorage.persistProp('dailyGoalDate', '')
    PersistentStorage.persistProp('autoSkip', false)
    PersistentStorage.persistProp('showQuotes', true)
    PersistentStorage.persistProp('currentStreak', 0)
    PersistentStorage.persistProp('maxStreak', 0)
    PersistentStorage.persistProp('achievementProgress', '')
    PersistentStorage.persistProp('selectedProgram', 'pomodoro')
    PersistentStorage.persistProp('themesUsedCount', 1)
    PersistentStorage.persistProp('programsUsedCount', 1)
    PersistentStorage.persistProp('earlyBirdCount', 0)
    PersistentStorage.persistProp('usedThemesList', 'purple')
    PersistentStorage.persistProp('usedProgramsList', 'pomodoro')
    PersistentStorage.persistProp('lastGoalDate', '')

    // Initialize database
    const dbService = DbService.getInstance()
    dbService.initialize(this.context).then(() => {
      hilog.info(0x0000, 'testTag', 'Database initialized')
    })

    // Initialize services
    AchievementService.getInstance().initialize()
    StreakTracker.getInstance().initialize()

    windowStage.loadContent('pages/NavigationContainer', (err: BusinessError) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
