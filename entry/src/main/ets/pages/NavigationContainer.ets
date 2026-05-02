import { Index } from './Index'
import { OnboardingPage } from './OnboardingPage'
import { StatsPage } from './StatsPage'
import { SettingsPage } from './SettingsPage'
import { AchievementsPage } from './AchievementsPage'
import { ProgramListPage } from './ProgramListPage'

@Entry
@Component
struct NavigationContainer {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private initialized: boolean = false

  @Builder
  routerMap(builderName: string, _param: object) {
    if (builderName === 'Index') {
      Index()
    } else if (builderName === 'Onboarding') {
      OnboardingPage()
    } else if (builderName === 'Stats') {
      StatsPage()
    } else if (builderName === 'Settings') {
      SettingsPage()
    } else if (builderName === 'Achievements') {
      AchievementsPage()
    } else if (builderName === 'ProgramList') {
      ProgramListPage()
    }
  }

  aboutToAppear() {

    this.pageInfos.pushPathByName('Index', null)

    return;

    if (this.initialized) {
      return
    }

    this.initialized = true
    const onboardingComplete = (AppStorage.get('onboardingComplete') as boolean) ?? false
    const startPage = onboardingComplete ? 'Index' : 'Onboarding'

    setTimeout(() => {
      this.pageInfos.clear()
      this.pageInfos.pushPathByName(startPage, null)
    }, 0)
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {}
    }
      .mode(NavigationMode.Stack)
      .navDestination(this.routerMap)
      .hideTitleBar(true)
  }
}
