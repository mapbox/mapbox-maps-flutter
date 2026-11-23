import 'dart:ui' show FontFeature, ImageFilter;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Mapbox design-system colors. Each hue is a 10-step ramp, and `50` is the
/// base step used for accents.
abstract final class MapboxColors {
  static const blue5 = Color(0xFFEFF7FF);
  static const blue10 = Color(0xFFCBE4FF);
  static const blue40 = Color(0xFF3195FF);
  static const blue50 = Color(0xFF007AFC);
  static const blue60 = Color(0xFF0062CA);
  static const blue90 = Color(0xFF001832);

  static const purple50 = Color(0xFF7539D7);
  static const orange50 = Color(0xFFFC8200);
  static const green50 = Color(0xFF228A56);
  static const green30 = Color(0xFF5CD79A);
  static const red50 = Color(0xFFF13219);
  static const yellow50 = Color(0xFFFED622);

  static const gray5 = Color(0xFFF7F9FC);
  static const gray10 = Color(0xFFECEFF5);
  static const gray15 = Color(0xFFE0E4EC);
  static const gray20 = Color(0xFFD5DAE2);
  static const gray35 = Color(0xFFAEB6C4);
  static const gray50 = Color(0xFF8B96AA);
  static const gray60 = Color(0xFF566171);
  static const gray70 = Color(0xFF333943);
  static const gray80 = Color(0xFF23262D);
  static const gray85 = Color(0xFF1C1F24);
  static const gray90 = Color(0xFF15171B);
  static const gray95 = Color(0xFF0E1012);
}

/// Corner radii from the Mapbox design system.
abstract final class MapboxRadius {
  static const tiny = 4.0;
  static const xsmall = 6.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const xlarge = 20.0;
}

const brandFontFallback = [
  'Inter',
  'SF Pro Display',
  'Helvetica Neue',
  'Segoe UI',
  'Roboto',
  'sans-serif',
];

/// Dark chrome that floats over the map: a translucent near-black panel with
/// a hairline border.
abstract final class MapboxGlass {
  static const fill = Color(0xCC0E1012);
  static const fillRaised = Color(0x14FFFFFF);
  static const fillSelected = Color(0x1FFFFFFF);
  static const border = Color(0x1FFFFFFF);
  static const borderStrong = Color(0x3DFFFFFF);
  static const blur = 24.0;

  static const label = Color(0xFFFFFFFF);
  static const labelMuted = Color(0xB3FFFFFF);
  static const labelFaint = Color(0x80FFFFFF);
}

ThemeData buildExampleTheme() {
  const scheme = ColorScheme.dark(
    primary: MapboxColors.blue40,
    onPrimary: Colors.white,
    primaryContainer: MapboxColors.blue50,
    onPrimaryContainer: Colors.white,
    secondary: MapboxColors.green30,
    onSecondary: MapboxColors.gray95,
    secondaryContainer: MapboxColors.gray80,
    onSecondaryContainer: MapboxGlass.labelMuted,
    tertiary: MapboxColors.orange50,
    surface: MapboxColors.gray95,
    onSurface: Colors.white,
    surfaceContainer: MapboxColors.gray90,
    surfaceContainerHighest: MapboxColors.gray80,
    outline: MapboxGlass.border,
    outlineVariant: MapboxGlass.border,
    error: MapboxColors.red50,
  );

  final textTheme = const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.2),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontWeight: FontWeight.w600),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  ).apply(fontFamilyFallback: brandFontFallback);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamilyFallback: brandFontFallback,
    textTheme: textTheme,
    scaffoldBackgroundColor: MapboxColors.gray95,
    appBarTheme: const AppBarTheme(
      backgroundColor: MapboxColors.gray95,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        fontFamilyFallback: brandFontFallback,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MapboxColors.gray95,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.medium)),
        side: BorderSide(color: MapboxGlass.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: MapboxColors.blue50,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.small)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MapboxColors.blue40,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.xsmall)),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: MapboxGlass.labelMuted,
        selectedBackgroundColor: MapboxGlass.fillSelected,
        selectedForegroundColor: Colors.white,
        side: const BorderSide(color: MapboxGlass.border),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.small)),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MapboxColors.gray80,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontFamilyFallback: brandFontFallback,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.small),
        side: const BorderSide(color: MapboxGlass.border),
      ),
    ),
    cardTheme: const CardThemeData(
      color: MapboxColors.gray90,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.large)),
        side: BorderSide(color: MapboxGlass.border),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MapboxGlass.fillRaised,
      side: const BorderSide(color: MapboxGlass.border),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontFamilyFallback: brandFontFallback,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.xsmall),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? MapboxGlass.labelFaint
            : Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return MapboxGlass.fillRaised;
        }
        return states.contains(WidgetState.selected)
            ? MapboxColors.blue50
            : MapboxGlass.fillRaised;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) &&
                !states.contains(WidgetState.disabled)
            ? Colors.transparent
            : MapboxGlass.border,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: MapboxGlass.labelFaint,
      indicatorColor: MapboxColors.blue40,
      dividerColor: MapboxGlass.border,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: MapboxGlass.labelMuted,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(MapboxRadius.small)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: MapboxGlass.border,
      space: 1,
      thickness: 1,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: MapboxColors.gray85,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.medium),
        side: const BorderSide(color: MapboxGlass.border),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MapboxColors.gray90,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: MapboxGlass.borderStrong,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MapboxRadius.large),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MapboxColors.gray90,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.large),
        side: const BorderSide(color: MapboxGlass.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MapboxGlass.fillRaised,
      isDense: true,
      hintStyle: const TextStyle(color: MapboxGlass.labelFaint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.small),
        borderSide: const BorderSide(color: MapboxGlass.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.small),
        borderSide: const BorderSide(color: MapboxGlass.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MapboxRadius.small),
        borderSide: const BorderSide(color: MapboxColors.blue40, width: 1.5),
      ),
    ),
  );
}

/// A translucent dark panel that floats over the map.
///
/// The shared container for every map overlay in the app.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = MapboxRadius.large,
    this.opaque = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// Fills the panel instead of blurring what is behind it.
  ///
  /// The blur does not composite over the map's platform view, so a panel
  /// that carries dense text over the map must be opaque to stay readable.
  final bool opaque;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: opaque ? MapboxColors.gray90 : MapboxGlass.fill,
        borderRadius: borderRadius,
        border: Border.all(color: MapboxGlass.border),
      ),
      child: Padding(padding: padding, child: child),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: opaque
          ? surface
          : BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: MapboxGlass.blur,
                sigmaY: MapboxGlass.blur,
              ),
              child: surface,
            ),
    );
  }
}

/// Space a bottom-aligned map overlay leaves for the compact bar, which a
/// narrow viewport pins to the bottom edge.
const compactBarClearance = 68.0;

/// Width at or above which a scaffold shows its side panels instead of the
/// bottom compact bar, so the logo and attribution no longer need the extra
/// clearance [applyCatalogOrnamentDefaults] adds for that bar.
///
/// Matches the wider of `SceneScaffold` and `MapScaffold`'s own breakpoints,
/// so the clearance is dropped only once every scaffold has actually
/// switched to its wide layout.
const wideOrnamentBreakpoint = 900.0;

/// Applies the shared ornament defaults for the catalog's examples.
///
/// The web scale bar renders as an unstyled ruler, so it is hidden across the
/// catalog. Below [wideOrnamentBreakpoint], the logo and attribution get
/// extra bottom margin so a narrow viewport's compact bar never covers them;
/// a wide viewport has no such bar, so they keep their default margin.
///
/// Reflects the viewport width at the time the map is created. It does not
/// react to a later resize, e.g. dragging a browser window across the
/// breakpoint.
///
/// Not for the ornaments example, which lets the user control every ornament
/// directly, or the plain getting-started example, which shows the SDK's own
/// defaults.
void applyCatalogOrnamentDefaults(BuildContext context, MapboxMap mapboxMap) {
  final isWide = MediaQuery.sizeOf(context).width >= wideOrnamentBreakpoint;
  final marginBottom = isWide ? null : compactBarClearance;
  mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
  mapboxMap.logo.updateSettings(LogoSettings(marginBottom: marginBottom));
  mapboxMap.attribution.updateSettings(
    AttributionSettings(marginBottom: marginBottom),
  );
}

/// A live numeric readout pinned over the map.
///
/// For a value that changes while the user touches the map. The side panel
/// cannot show these: on a phone it is a sheet that covers the map.
///
/// Values use tabular figures, so a digit change does not shift the layout.
class MapHud extends StatelessWidget {
  const MapHud({
    super.key,
    required this.rows,
    this.title,
    this.alignment = Alignment.topCenter,
    this.width = 236,
  });

  final List<MapHudRow> rows;

  /// Optional caption above the rows.
  final String? title;

  /// Position within the map. Defaults to the top edge, clear of the corner
  /// ornaments and the side panels.
  final Alignment alignment;

  final double width;

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth - viewPadding.left - viewPadding.right - 24;
    // A bottom-aligned HUD must clear the compact bar that a narrow viewport
    // pins to the same edge.
    final clearsCompactBar = alignment.y > 0 && screenWidth < 640;
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12 + viewPadding.left,
          12 + viewPadding.top,
          12 + viewPadding.right,
          (clearsCompactBar ? compactBarClearance : 12) + viewPadding.bottom,
        ),
        child: SizedBox(
          width: width < maxWidth ? width : maxWidth,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            radius: MapboxRadius.medium,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  GlassSectionLabel(title!),
                  const SizedBox(height: 8),
                ],
                for (final row in rows) row,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One label/value line in a [MapHud].
class MapHudRow extends StatelessWidget {
  const MapHudRow(this.label, this.value, {super.key, this.emphasized = false});

  final String label;
  final String value;

  /// Draws the value brighter, for the one number an example is about.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MapboxGlass.labelFaint,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: emphasized ? MapboxGlass.label : MapboxGlass.labelMuted,
                fontSize: 11,
                height: 1.4,
                fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An uppercase, letterspaced section label.
class GlassSectionLabel extends StatelessWidget {
  const GlassSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: MapboxGlass.labelFaint,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        fontFamilyFallback: brandFontFallback,
      ),
    );
  }
}
