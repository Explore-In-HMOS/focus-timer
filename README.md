> **Note:** To access all shared projects, get information about environment setup, and view other guides, please visit [Explore-In-HMOS-Wearable Index](https://github.com/Explore-In-HMOS-Wearable/hmos-index).

# Focus Timer

Focus Timer app helps users to stay focused and productive by using timed work intervals with short and long breaks. It
is based on the Pomodoro Technique. The app features session tracking with a local database, daily goals, achievement system, breathing exercises, multiple focus programs, theme customization, and detailed statistics with Canvas-based charts — all optimized for circular wearable displays.

# Preview

<div>
  <img src="screenshots/ss1.png" width="24%">
  <img src="screenshots/ss2.png" width="24%">
  <img src="screenshots/ss3.png" width="24%">
  <img src="screenshots/ss4.png" width="24%">
</div>

# Use Cases

- Focus Timer provides the best way to stay focused with short and long breaks based on the Pomodoro Technique.
- Controller is the first page of the application. It is used to control the active focus session. You can start, stop or reset the active session or skip the next one.
- Track the active focus session.
- Set default times for focus sessions.

**Newly Added**

- **Onboarding Flow**: Step-by-step welcome experience using Stepper component with goal setting and theme selection on first launch.
- **Session History & Statistics**: All completed sessions are recorded in a relational database (RDB). View daily, weekly, and monthly stats with Canvas-based bar charts and pie charts.
- **Calendar Heatmap**: GitHub-style contribution heatmap showing focus activity over the last 14 weeks, rendered with Canvas API.
- **Daily Focus Goals**: Set a daily target and track progress with a Gauge ring. Celebration animation on goal completion.
- **Achievement & Badge System**: 15 unlockable badges across sessions, minutes, streaks, and exploration categories. Grid gallery with lock/unlock animations and progress bars.
- **Session Tags**: Categorize focus sessions with color-coded Chip components (Work, Study, Coding, Exercise, Reading, Meditation). Filter statistics by category.
- **Focus Programs**: 4 preset templates — Pomodoro (25/5/20), Deep Work (90/20/30), Sprint (15/3/10), Study (50/10/25). Visual cycle dot preview for each program.
- **Breathing Exercise**: Guided 4-7-8 breathing technique with animated expanding/contracting circles using animateTo and Curve.EaseInOut.
- **Theme Customization**: 6 color themes (Purple, Blue, Green, Red, Orange, Cyan) with live preview and persistent selection.
- **Intensity Levels**: Light, Normal, and Intense modes with DataPanel visualization and focus/break time multipliers.
- **Streak Tracking**: Consecutive day counter with current and best streak tracking.
- **Break Activity Suggestions**: Swiper-based activity cards (Walk, Hydrate, Eye Rest, Stretch, Relax) with built-in mini timers.
- **Pomodoro Cycle Visualizer**: Canvas-drawn circular diagram showing all segments in the current cycle with progress overlay on the active segment.
- **Motivational Quotes**: Marquee-scrolling quotes from productivity leaders, displayed during idle state on the timer ring.
- **Settings Page**: Grouped list settings with Toggle switches, Slider for goal adjustment, Navigation links to sub-pages, and theme/intensity pickers.
- **Custom Dialogs**: Session completion summary, achievement unlock celebration, and confirmation dialogs using @CustomDialog with animated transitions and backdrop blur.
- **Router Navigation**: Multi-page navigation with router.pushUrl between Index, Stats, Settings, Achievements, and Programs pages.
- **Persistent Storage**: All user preferences, goals, streaks, and achievement progress are saved via PersistentStorage and restored across app launches.
- **RDB Database**: Full relational database layer using @kit.ArkData relationalStore for session records and daily aggregated statistics.

# Tech Stack

- **Languages**: ArkTS, ArkUI
- **Frameworks**: HarmonyOS SDK 5.0.2(14)
- **Tools**: DevEco Studio Vers 5.1.0.820
- **Libraries**: @kit.ArkUI, @kit.AbilityKit, @kit.ArkData (relationalStore, preferences), @kit.BasicServicesKit, @kit.CoreFileKit, @kit.PerformanceAnalysisKit, @ohos.arkui.advanced.Counter
- **ArkUI Components**: ArcSwiper, Canvas, Gauge, DataPanel, Stepper, Slider, Toggle, Marquee, Swiper, Grid, Flex, CustomDialog, Progress, Scroll, List, ListItemGroup, Circle, SymbolGlyph, animateTo, TransitionEffect, router

# Directory Structure

```
entry/src/main/ets/
├───components
│       BadgeCard.ets
│       BreakSuggestions.ets
│       BreathingExercise.ets
│       CalendarHeatmap.ets
│       CycleVisualizer.ets
│       FocusDialog.ets
│       GoalRingView.ets
│       IntensitySelector.ets
│       ProgressController.ets
│       ProgressRing.ets
│       ProgressTimes.ets
│       QuotesProvider.ets
│       StatsChart.ets
│       TagSelector.ets
│       ThemePickerView.ets
├───constants
│       SizeConstants.ets
├───entryability
│       EntryAbility.ets
├───entrybackupability
│       EntryBackupAbility.ets
├───model
│       Achievement.ets
│       Focus.ets
│       FocusType.ets
│       GoalModel.ets
│       IntensityModel.ets
│       Program.ets
│       ProgramTemplate.ets
│       SessionRecord.ets
│       TagModel.ets
│       ThemeModel.ets
│       Timer.ets
├───pages
│       AchievementsPage.ets
│       Index.ets
│       OnboardingPage.ets
│       ProgramListPage.ets
│       SettingsPage.ets
│       StatsPage.ets
└───service
        AchievementService.ets
        DbService.ets
        StreakTracker.ets
```

# Constraints and Restrictions

## Supported Device
- Huawei Watch 5

# LICENSE

**Focus Timer** is distributed under the terms of the MIT License.
See the [license](LICENSE) for more information. 