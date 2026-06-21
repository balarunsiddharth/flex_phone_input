import 'package:flutter/foundation.dart';

/// An immutable description of a country/territory used by the phone field.
///
/// [isoCode] is an ISO 3166-1 alpha-2 code (uppercase, e.g. `IN`) and
/// [dialCode] is the E.164 calling code **without** the leading `+`
/// (e.g. `91`, or `1242` for NANP territories).
@immutable
class Country {
  /// Creates a country description.
  const Country({
    required this.name,
    required this.isoCode,
    required this.dialCode,
  });

  /// Human-readable country name (e.g. `India`).
  final String name;

  /// ISO 3166-1 alpha-2 code, uppercase (e.g. `IN`).
  final String isoCode;

  /// E.164 calling code without the leading `+` (e.g. `91`).
  final String dialCode;

  /// The Unicode flag emoji derived from [isoCode] using regional-indicator
  /// symbols.
  ///
  /// Note: emoji flags render inconsistently on some Android devices. To ship
  /// image flags instead, supply a `flagBuilder` to [PhoneNumberInput] /
  /// [CountryFlag].
  String get flagEmoji {
    final String code = isoCode.toUpperCase();
    if (code.length != 2) return '';
    const int base = 0x1F1E6; // Regional Indicator Symbol Letter A.
    final int a = code.codeUnitAt(0);
    final int b = code.codeUnitAt(1);
    if (a < 0x41 || a > 0x5A || b < 0x41 || b > 0x5A) return '';
    return String.fromCharCode(base + (a - 0x41)) +
        String.fromCharCode(base + (b - 0x41));
  }

  /// The calling code prefixed with `+` (e.g. `+91`).
  String get displayDialCode => '+$dialCode';

  /// Returns a copy with the given fields replaced.
  Country copyWith({String? name, String? isoCode, String? dialCode}) {
    return Country(
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          other.isoCode == isoCode &&
          other.dialCode == dialCode &&
          other.name == name;

  @override
  int get hashCode => Object.hash(name, isoCode, dialCode);

  @override
  String toString() => 'Country($isoCode, +$dialCode, $name)';
}
