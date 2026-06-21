import 'package:flutter/material.dart';

double _lerpD(double a, double b, double t) => a + (b - a) * t;

/// A fully configurable theme for [PhoneNumberInput] and the country selector.
///
/// There are three ways to apply it, in increasing specificity:
///
/// 1. **Globally**, via your app's [ThemeData.extensions]:
///    ```dart
///    MaterialApp(
///      theme: ThemeData.light().copyWith(
///        extensions: [PhoneInputTheme.light()],
///      ),
///      darkTheme: ThemeData.dark().copyWith(
///        extensions: [PhoneInputTheme.dark()],
///      ),
///    );
///    ```
/// 2. **Derived from your color scheme**, so it matches the rest of your app:
///    ```dart
///    extensions: [PhoneInputTheme.fromColorScheme(Theme.of(context).colorScheme)]
///    ```
/// 3. **Per-widget**, by passing `theme:` directly to [PhoneNumberInput].
///
/// If none is provided, the widget falls back to [PhoneInputTheme.light] /
/// [PhoneInputTheme.dark] based on the ambient [Brightness].
///
/// Tweak a single token with [copyWith]:
/// ```dart
/// PhoneInputTheme.light().copyWith(focusedBorderColor: Colors.deepPurple)
/// ```
@immutable
class PhoneInputTheme extends ThemeExtension<PhoneInputTheme> {
  /// Creates a phone-input theme. All tokens are required; prefer the
  /// [PhoneInputTheme.light], [PhoneInputTheme.dark] or
  /// [PhoneInputTheme.fromColorScheme] factories and override via [copyWith].
  const PhoneInputTheme({
    required this.fillColor,
    required this.textColor,
    required this.hintColor,
    required this.labelColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.errorColor,
    required this.successColor,
    required this.iconColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.contentPadding,
    required this.inputTextStyle,
    required this.hintTextStyle,
    required this.dialCodeTextStyle,
    required this.labelTextStyle,
    required this.helperTextStyle,
    required this.errorTextStyle,
    required this.surfaceColor,
    required this.surfaceTextColor,
    required this.surfaceMutedColor,
    required this.searchFillColor,
    required this.selectedTileColor,
    required this.sectionHeaderColor,
    required this.dividerColor,
    required this.dragHandleColor,
    required this.scrimColor,
  });

  // ----- Field tokens -----
  /// Background of the input box (used when the variant is filled).
  final Color fillColor;

  /// Color of the entered number text and selected dial code.
  final Color textColor;

  /// Placeholder / hint color.
  final Color hintColor;

  /// Floating label color.
  final Color labelColor;

  /// Resting border color.
  final Color borderColor;

  /// Border color when the field is focused.
  final Color focusedBorderColor;

  /// Accent color for the error state.
  final Color errorColor;

  /// Accent color for the valid state.
  final Color successColor;

  /// Color of the dropdown chevron icon on the country trigger.
  final Color iconColor;

  /// Corner radius of the input box (ignored for the pill variant).
  final double borderRadius;

  /// Resting border width.
  final double borderWidth;

  /// Border width when focused.
  final double focusedBorderWidth;

  /// Internal padding of the input box.
  final EdgeInsetsGeometry contentPadding;

  /// Text style for the entered number (color is taken from [textColor]).
  final TextStyle inputTextStyle;

  /// Text style for the placeholder (color from [hintColor]).
  final TextStyle hintTextStyle;

  /// Text style for the dial-code prefix (color from [textColor]).
  final TextStyle dialCodeTextStyle;

  /// Text style for the floating label (color from [labelColor]).
  final TextStyle labelTextStyle;

  /// Text style for helper text (color from [hintColor]).
  final TextStyle helperTextStyle;

  /// Text style for error text (color from [errorColor]).
  final TextStyle errorTextStyle;

  // ----- Selector surface tokens -----
  /// Background of the selector surface (sheet / dialog / page / dropdown).
  final Color surfaceColor;

  /// Primary text color inside the selector (country names).
  final Color surfaceTextColor;

  /// Muted text inside the selector (dial codes, section labels).
  final Color surfaceMutedColor;

  /// Background of the selector's search field.
  final Color searchFillColor;

  /// Highlight color of the currently-selected country row.
  final Color selectedTileColor;

  /// Color of section headers ("POPULAR" / "ALL COUNTRIES").
  final Color sectionHeaderColor;

  /// Divider / hairline color inside the selector.
  final Color dividerColor;

  /// Color of the bottom-sheet drag handle.
  final Color dragHandleColor;

  /// Scrim color behind modal surfaces.
  final Color scrimColor;

  /// The default light theme, using the package's reference design tokens.
  factory PhoneInputTheme.light() {
    const Color primary = Color(0xFF1A56DB);
    return PhoneInputTheme(
      fillColor: const Color(0xFFF3F4F6),
      textColor: const Color(0xFF111928),
      hintColor: const Color(0xFF9CA3AF),
      labelColor: const Color(0xFF6B7280),
      borderColor: const Color(0xFFE5E7EB),
      focusedBorderColor: primary,
      errorColor: const Color(0xFFE02424),
      successColor: const Color(0xFF0E9F6E),
      iconColor: const Color(0xFF6B7280),
      borderRadius: 8,
      borderWidth: 1,
      focusedBorderWidth: 1.6,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      inputTextStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      hintTextStyle: const TextStyle(fontSize: 16),
      dialCodeTextStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      labelTextStyle: const TextStyle(fontSize: 14),
      helperTextStyle: const TextStyle(fontSize: 12),
      errorTextStyle: const TextStyle(fontSize: 12),
      surfaceColor: const Color(0xFFFFFFFF),
      surfaceTextColor: const Color(0xFF111928),
      surfaceMutedColor: const Color(0xFF6B7280),
      searchFillColor: const Color(0xFFF3F4F6),
      selectedTileColor: const Color(0xFFEBF5FF),
      sectionHeaderColor: const Color(0xFF9CA3AF),
      dividerColor: const Color(0xFFE5E7EB),
      dragHandleColor: const Color(0xFFD1D5DB),
      scrimColor: const Color(0x73030B33),
    );
  }

  /// The default dark theme, using the package's reference design tokens.
  factory PhoneInputTheme.dark() {
    const Color primary = Color(0xFF3F83F8);
    return PhoneInputTheme(
      fillColor: const Color(0xFF1F2937),
      textColor: const Color(0xFFF9FAFB),
      hintColor: const Color(0xFF6B7280),
      labelColor: const Color(0xFF9CA3AF),
      borderColor: const Color(0xFF374151),
      focusedBorderColor: primary,
      errorColor: const Color(0xFFF98080),
      successColor: const Color(0xFF31C48D),
      iconColor: const Color(0xFF9CA3AF),
      borderRadius: 8,
      borderWidth: 1,
      focusedBorderWidth: 1.6,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      inputTextStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      hintTextStyle: const TextStyle(fontSize: 16),
      dialCodeTextStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      labelTextStyle: const TextStyle(fontSize: 14),
      helperTextStyle: const TextStyle(fontSize: 12),
      errorTextStyle: const TextStyle(fontSize: 12),
      surfaceColor: const Color(0xFF111928),
      surfaceTextColor: const Color(0xFFF9FAFB),
      surfaceMutedColor: const Color(0xFF9CA3AF),
      searchFillColor: const Color(0xFF1F2937),
      selectedTileColor: const Color(0x2E3F83F8), // primary @ ~18%
      sectionHeaderColor: const Color(0xFF6B7280),
      dividerColor: const Color(0xFF374151),
      dragHandleColor: const Color(0xFF4B5563),
      scrimColor: const Color(0x9E000000),
    );
  }

  /// Builds a theme from a Material [ColorScheme], so the field matches the
  /// rest of your app. Brightness is taken from [scheme].
  factory PhoneInputTheme.fromColorScheme(ColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;
    final PhoneInputTheme base =
        isDark ? PhoneInputTheme.dark() : PhoneInputTheme.light();
    return base.copyWith(
      fillColor: scheme.surfaceContainerHighest,
      textColor: scheme.onSurface,
      hintColor: scheme.onSurfaceVariant,
      labelColor: scheme.onSurfaceVariant,
      borderColor: scheme.outlineVariant,
      focusedBorderColor: scheme.primary,
      errorColor: scheme.error,
      iconColor: scheme.onSurfaceVariant,
      surfaceColor: scheme.surface,
      surfaceTextColor: scheme.onSurface,
      surfaceMutedColor: scheme.onSurfaceVariant,
      searchFillColor: scheme.surfaceContainerHighest,
      selectedTileColor: scheme.primaryContainer,
      sectionHeaderColor: scheme.onSurfaceVariant,
      dividerColor: scheme.outlineVariant,
      dragHandleColor: scheme.outlineVariant,
    );
  }

  @override
  PhoneInputTheme copyWith({
    Color? fillColor,
    Color? textColor,
    Color? hintColor,
    Color? labelColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorColor,
    Color? successColor,
    Color? iconColor,
    double? borderRadius,
    double? borderWidth,
    double? focusedBorderWidth,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? inputTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? dialCodeTextStyle,
    TextStyle? labelTextStyle,
    TextStyle? helperTextStyle,
    TextStyle? errorTextStyle,
    Color? surfaceColor,
    Color? surfaceTextColor,
    Color? surfaceMutedColor,
    Color? searchFillColor,
    Color? selectedTileColor,
    Color? sectionHeaderColor,
    Color? dividerColor,
    Color? dragHandleColor,
    Color? scrimColor,
  }) {
    return PhoneInputTheme(
      fillColor: fillColor ?? this.fillColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      labelColor: labelColor ?? this.labelColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      iconColor: iconColor ?? this.iconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      contentPadding: contentPadding ?? this.contentPadding,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      dialCodeTextStyle: dialCodeTextStyle ?? this.dialCodeTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      helperTextStyle: helperTextStyle ?? this.helperTextStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      surfaceTextColor: surfaceTextColor ?? this.surfaceTextColor,
      surfaceMutedColor: surfaceMutedColor ?? this.surfaceMutedColor,
      searchFillColor: searchFillColor ?? this.searchFillColor,
      selectedTileColor: selectedTileColor ?? this.selectedTileColor,
      sectionHeaderColor: sectionHeaderColor ?? this.sectionHeaderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      scrimColor: scrimColor ?? this.scrimColor,
    );
  }

  @override
  PhoneInputTheme lerp(covariant ThemeExtension<PhoneInputTheme>? other, double t) {
    if (other is! PhoneInputTheme) return this;
    return PhoneInputTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      focusedBorderColor:
          Color.lerp(focusedBorderColor, other.focusedBorderColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      borderRadius: _lerpD(borderRadius, other.borderRadius, t),
      borderWidth: _lerpD(borderWidth, other.borderWidth, t),
      focusedBorderWidth:
          _lerpD(focusedBorderWidth, other.focusedBorderWidth, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t)!,
      inputTextStyle: TextStyle.lerp(inputTextStyle, other.inputTextStyle, t)!,
      hintTextStyle: TextStyle.lerp(hintTextStyle, other.hintTextStyle, t)!,
      dialCodeTextStyle:
          TextStyle.lerp(dialCodeTextStyle, other.dialCodeTextStyle, t)!,
      labelTextStyle: TextStyle.lerp(labelTextStyle, other.labelTextStyle, t)!,
      helperTextStyle:
          TextStyle.lerp(helperTextStyle, other.helperTextStyle, t)!,
      errorTextStyle: TextStyle.lerp(errorTextStyle, other.errorTextStyle, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      surfaceTextColor:
          Color.lerp(surfaceTextColor, other.surfaceTextColor, t)!,
      surfaceMutedColor:
          Color.lerp(surfaceMutedColor, other.surfaceMutedColor, t)!,
      searchFillColor: Color.lerp(searchFillColor, other.searchFillColor, t)!,
      selectedTileColor:
          Color.lerp(selectedTileColor, other.selectedTileColor, t)!,
      sectionHeaderColor:
          Color.lerp(sectionHeaderColor, other.sectionHeaderColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      dragHandleColor: Color.lerp(dragHandleColor, other.dragHandleColor, t)!,
      scrimColor: Color.lerp(scrimColor, other.scrimColor, t)!,
    );
  }
}
