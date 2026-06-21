import 'package:flutter/widgets.dart';

import '../models/country.dart';

/// Builds a custom flag widget for [country] at the requested [size].
///
/// Supply this to render image flags (recommended on Android, where emoji
/// flags are inconsistent) instead of the default emoji. For example, using
/// the `country_flags` package:
///
/// ```dart
/// flagBuilder: (context, country, size) =>
///     CountryFlag.fromCountryCode(country.isoCode, height: size, width: size * 1.4),
/// ```
typedef CountryFlagBuilder = Widget Function(
  BuildContext context,
  Country country,
  double size,
);

/// Renders a country's flag — an emoji by default, or whatever [builder]
/// returns.
class CountryFlag extends StatelessWidget {
  /// Creates a flag widget for [country].
  const CountryFlag({
    super.key,
    required this.country,
    this.size = 22,
    this.builder,
  });

  /// The country whose flag is shown.
  final Country country;

  /// The nominal flag size (font size for the emoji fallback).
  final double size;

  /// Optional custom renderer; see [CountryFlagBuilder].
  final CountryFlagBuilder? builder;

  @override
  Widget build(BuildContext context) {
    if (builder != null) return builder!(context, country, size);
    return Text(
      country.flagEmoji,
      style: TextStyle(fontSize: size, height: 1.0),
    );
  }
}
