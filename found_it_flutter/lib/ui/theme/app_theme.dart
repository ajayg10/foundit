import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_semantic.dart';
import 'app_spacing.dart';
import 'app_text.dart';

/// Builds the two complete ThemeData objects (light + dark) for Found It.
/// Everything comes from the token tables — no default M3 purple leaks through.
abstract final class FoundItTheme {
  // ── Light ─────────────────────────────────────────────────────────────

  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: AppSemantic.light,
    systemUiStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColorsLight.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // ── Dark ──────────────────────────────────────────────────────────────

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: AppSemantic.dark,
    systemUiStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColorsDark.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── Internal builder ──────────────────────────────────────────────────

  static ThemeData _build({
    required Brightness brightness,
    required AppSemantic colors,
    required SystemUiOverlayStyle systemUiStyle,
  }) {
    final isLight = brightness == Brightness.light;

    // ColorScheme built from tokens — no fromSeed()
    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.brand,
      onPrimary: colors.onBrand,
      primaryContainer: colors.brand,
      onPrimaryContainer: colors.onBrand,
      secondary: colors.found,
      onSecondary: isLight ? AppColorsLight.surface : AppColorsDark.surface,
      secondaryContainer: colors.foundSoft,
      onSecondaryContainer: colors.found,
      tertiary: colors.lost,
      onTertiary: isLight ? AppColorsLight.surface : AppColorsDark.surface,
      tertiaryContainer: colors.lostSoft,
      onTertiaryContainer: colors.lost,
      error: colors.error,
      onError: isLight ? AppColorsLight.surface : AppColorsDark.surface,
      errorContainer: colors.errorSoft,
      onErrorContainer: colors.error,
      surface: colors.surface,
      onSurface: colors.ink,
      onSurfaceVariant: colors.muted,
      outline: colors.line,
      outlineVariant: colors.line,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: colors.ink,
      onInverseSurface: colors.surface,
      inversePrimary: colors.onBrand,
      surfaceTint: Colors.transparent, // suppress M3 tonal surface tinting
    );

    final textTheme = AppText.buildTextTheme(colors.ink, colors.muted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.bg,
      textTheme: textTheme,
      extensions: [colors],

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: systemUiStyle,
        titleTextStyle: AppText.h2(colors.ink),
        iconTheme: IconThemeData(color: colors.ink, size: 22),
        actionsIconTheme: IconThemeData(color: colors.ink, size: 22),
        shape: Border(bottom: BorderSide(color: colors.line, width: 1)),
      ),

      // ── Navigation bar (bottom) ────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: colors.brand,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.onBrand, size: 22);
          }
          return IconThemeData(color: colors.muted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppText.caption(
              colors.ink,
            ).copyWith(fontWeight: FontWeight.w600);
          }
          return AppText.caption(colors.muted);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        shadowColor: Colors.transparent,
      ),

      // ── Tab bar ────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: colors.ink,
        unselectedLabelColor: colors.muted,
        indicatorColor: colors.ink,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: colors.line,
        labelStyle: AppText.label(colors.ink),
        unselectedLabelStyle: AppText.body(colors.muted),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Buttons ────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.onBrand,
          disabledBackgroundColor: colors.line,
          disabledForegroundColor: colors.muted,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBr),
          textStyle: AppText.label(colors.onBrand),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.onBrand,
          disabledBackgroundColor: colors.line,
          disabledForegroundColor: colors.muted,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBr),
          textStyle: AppText.label(colors.onBrand),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.ink,
          disabledForegroundColor: colors.muted,
          side: BorderSide(color: colors.line, width: 1),
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBr),
          textStyle: AppText.label(colors.ink),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brand,
          disabledForegroundColor: colors.muted,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          textStyle: AppText.label(colors.brand),
        ),
      ),

      // ── Input decoration ───────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.brand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonBr,
          borderSide: BorderSide(color: colors.line),
        ),
        hintStyle: AppText.body(colors.muted),
        labelStyle: AppText.label(colors.muted),
        floatingLabelStyle: AppText.label(colors.brand),
        errorStyle: AppText.caption(colors.error),
        helperStyle: AppText.caption(colors.muted),
        prefixIconColor: colors.muted,
        suffixIconColor: colors.muted,
      ),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.tileBr,
          side: BorderSide(color: colors.line),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.ink,
        disabledColor: colors.line,
        labelStyle: AppText.caption(colors.ink),
        secondaryLabelStyle: AppText.caption(colors.surface),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.pillBr,
          side: BorderSide(color: colors.line),
        ),
        side: BorderSide(color: colors.line),
        elevation: 0,
        pressElevation: 0,
        brightness: brightness,
      ),

      // ── Dialog ────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.panelBr),
        titleTextStyle: AppText.h2(colors.ink),
        contentTextStyle: AppText.body(colors.ink),
      ),

      // ── Bottom sheet ─────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetBr),
        showDragHandle: true,
        dragHandleColor: colors.line,
        dragHandleSize: const Size(40, 4),
        constraints: const BoxConstraints(maxWidth: 640),
      ),

      // ── Snackbar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.ink,
        contentTextStyle: AppText.body(colors.surface),
        actionTextColor: colors.found,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        elevation: 0,
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: 1,
        space: 1,
      ),

      // ── ListTile ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: colors.surface,
        textColor: colors.ink,
        iconColor: colors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s4,
        ),
        minLeadingWidth: 24,
        minVerticalPadding: AppSpacing.s12,
      ),

      // ── Switch ────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.onBrand;
          return colors.muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand;
          return colors.line;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Checkbox ──────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colors.onBrand),
        side: BorderSide(color: colors.line, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Progress indicator ────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.brand,
        linearTrackColor: colors.line,
        circularTrackColor: colors.line,
        linearMinHeight: 2,
      ),

      // ── Page transitions ──────────────────────────────────────────────
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        },
      ),

      // ── Icon ──────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: colors.muted, size: 22),
      primaryIconTheme: IconThemeData(color: colors.onBrand, size: 22),
    );
  }
}
