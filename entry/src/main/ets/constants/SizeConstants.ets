export class SizeConstants {
  static readonly FULL_WIDTH_PERCENT: string = '100%';
  static readonly FULL_HEIGHT_PERCENT: string = '100%';
  static readonly PERCENT_70 = '70%';
  static readonly PERCENT_80 = '80%';
  static readonly PERCENT_90 = '90%';
  static readonly PERCENT_50 = '50%';

  // Circular display safe-area. Huawei Watch 5 (466x466) inscribed square ≈ 70%
  // of diameter, so top/bottom arcs ~34vp each are clipped. Use generous insets.
  static readonly PAGE_SIDE_PADDING: number = 16;
  static readonly PAGE_HEADER_TOP_PADDING: number = 30;
  static readonly PAGE_CONTENT_BOTTOM_PADDING: number = 56;
  static readonly FLOATING_BUTTON_TOP_OFFSET: number = 24;

  // Tap targets — HarmonyOS wearable minimum is 36vp.
  static readonly TAP_TARGET_MIN: number = 36;
  static readonly HEADER_BUTTON_SIZE: number = 32;
  static readonly HEADER_BUTTON_RADIUS: number = 16;

  // Dialog inset width on circular display.
  static readonly DIALOG_WIDTH_PERCENT: string = '86%';
}
