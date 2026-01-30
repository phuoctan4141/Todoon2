import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6f5d0e),
      surfaceTint: Color(0xff6f5d0e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfffae287),
      onPrimaryContainer: Color(0xff544600),
      secondary: Color(0xff046b5c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa0f2df),
      onSecondaryContainer: Color(0xff005045),
      tertiary: Color(0xff784f83),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffbd7ff),
      onTertiaryContainer: Color(0xff5e3869),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff9ef),
      onSurface: Color(0xff1e1b13),
      onSurfaceVariant: Color(0xff4b4739),
      outline: Color(0xff7c7767),
      outlineVariant: Color(0xffcdc6b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffddc66e),
      primaryFixed: Color(0xfffae287),
      onPrimaryFixed: Color(0xff221b00),
      primaryFixedDim: Color(0xffddc66e),
      onPrimaryFixedVariant: Color(0xff544600),
      secondaryFixed: Color(0xffa0f2df),
      onSecondaryFixed: Color(0xff00201b),
      secondaryFixedDim: Color(0xff84d6c3),
      onSecondaryFixedVariant: Color(0xff005045),
      tertiaryFixed: Color(0xfffbd7ff),
      onTertiaryFixed: Color(0xff2f0a3b),
      tertiaryFixedDim: Color(0xffe7b6f0),
      onTertiaryFixedVariant: Color(0xff5e3869),
      surfaceDim: Color(0xffe0d9cc),
      surfaceBright: Color(0xfffff9ef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf3e5),
      surfaceContainer: Color(0xfff4eddf),
      surfaceContainerHigh: Color(0xffefe7da),
      surfaceContainerHighest: Color(0xffe9e2d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff413500),
      surfaceTint: Color(0xff6f5d0e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7e6c1d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003e35),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff217a6a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4c2757),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff885e92),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff9ef),
      onSurface: Color(0xff131109),
      onSurfaceVariant: Color(0xff3a3629),
      outline: Color(0xff575244),
      outlineVariant: Color(0xff726d5e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffddc66e),
      primaryFixed: Color(0xff7e6c1d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff645402),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff217a6a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff006052),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff885e92),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6e4678),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffccc6b9),
      surfaceBright: Color(0xfffff9ef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf3e5),
      surfaceContainer: Color(0xffefe7da),
      surfaceContainerHigh: Color(0xffe3dccf),
      surfaceContainerHighest: Color(0xffd8d1c4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff352b00),
      surfaceTint: Color(0xff6f5d0e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff574800),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00332b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005347),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff411d4d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff613a6c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff9ef),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff302c20),
      outlineVariant: Color(0xff4d493b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffddc66e),
      primaryFixed: Color(0xff574800),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3d3200),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005347),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003a31),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff613a6c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff492354),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbeb8ab),
      surfaceBright: Color(0xfffff9ef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f0e2),
      surfaceContainer: Color(0xffe9e2d4),
      surfaceContainerHigh: Color(0xffdad4c6),
      surfaceContainerHighest: Color(0xffccc6b9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb5c4ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff1c2d61),
      primaryContainer: Color(0xff344479),
      onPrimaryContainer: Color(0xffdce1ff),
      secondary: Color(0xffdcc66e),
      onSecondary: Color(0xff3a3000),
      secondaryContainer: Color(0xff544600),
      onSecondaryContainer: Color(0xfffae287),
      tertiary: Color(0xffa5d396),
      onTertiary: Color(0xff11380b),
      tertiaryContainer: Color(0xff285020),
      onTertiaryContainer: Color(0xffc0efb0),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe3e1e9),
      onSurfaceVariant: Color(0xffc6c6d0),
      outline: Color(0xff8f909a),
      outlineVariant: Color(0xff45464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff4c5c92),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff02174b),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff344479),
      secondaryFixed: Color(0xfffae287),
      onSecondaryFixed: Color(0xff221b00),
      secondaryFixedDim: Color(0xffdcc66e),
      onSecondaryFixedVariant: Color(0xff544600),
      tertiaryFixed: Color(0xffc0efb0),
      onTertiaryFixed: Color(0xff002200),
      tertiaryFixedDim: Color(0xffa5d396),
      onTertiaryFixedVariant: Color(0xff285020),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff292a2f),
      surfaceContainerHighest: Color(0xff34343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd3dbff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff102255),
      primaryContainer: Color(0xff7f8ec8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff3dc81),
      onSecondary: Color(0xff2e2500),
      secondaryContainer: Color(0xffa4903e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffbae9aa),
      onTertiary: Color(0xff042d03),
      tertiaryContainer: Color(0xff709c64),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdcdbe6),
      outline: Color(0xffb1b1bb),
      outlineVariant: Color(0xff8f9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff35457a),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff000d37),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff233367),
      secondaryFixed: Color(0xfffae287),
      onSecondaryFixed: Color(0xff161100),
      secondaryFixedDim: Color(0xffdcc66e),
      onSecondaryFixedVariant: Color(0xff413500),
      tertiaryFixed: Color(0xffc0efb0),
      onTertiaryFixed: Color(0xff001600),
      tertiaryFixedDim: Color(0xffa5d396),
      onTertiaryFixedVariant: Color(0xff173e11),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff43444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1c1d23),
      surfaceContainer: Color(0xff27282d),
      surfaceContainerHigh: Color(0xff313238),
      surfaceContainerHighest: Color(0xff3d3d43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffeeefff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb1c0fd),
      onPrimaryContainer: Color(0xff00082a),
      secondary: Color(0xfffff0bd),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd8c26b),
      onSecondaryContainer: Color(0xff0f0b00),
      tertiary: Color(0xffcdfdbc),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa1cf92),
      onTertiaryContainer: Color(0xff000f00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff0effa),
      outlineVariant: Color(0xffc2c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff35457a),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff000d37),
      secondaryFixed: Color(0xfffae287),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffdcc66e),
      onSecondaryFixedVariant: Color(0xff161100),
      tertiaryFixed: Color(0xffc0efb0),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5d396),
      onTertiaryFixedVariant: Color(0xff001600),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff4f5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e1f25),
      surfaceContainer: Color(0xff2f3036),
      surfaceContainerHigh: Color(0xff3a3b41),
      surfaceContainerHighest: Color(0xff46464c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  // == Theme for All ==
  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
          color: colorScheme.onPrimaryContainer,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: colorScheme.onErrorContainer),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: colorScheme.onErrorContainer),
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    ),
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
