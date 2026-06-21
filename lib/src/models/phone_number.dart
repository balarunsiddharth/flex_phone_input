import 'package:flutter/foundation.dart';

import 'country.dart';

/// The value produced by [PhoneNumber]'s field: a [country] plus the national
/// [number] (digits only, without the dial code or separators).
@immutable
class PhoneNumber {
  /// Creates a phone number value.
  const PhoneNumber({required this.country, required this.number});

  /// The selected country (carries the dial code and flag).
  final Country country;

  /// National significant number — digits only, no `+`, dial code or spaces.
  final String number;

  /// The full E.164-style number: `+<dialCode><number>` (e.g. `+919876543210`).
  String get completeNumber => '+${country.dialCode}$number';

  /// Alias for [completeNumber].
  String get e164 => completeNumber;

  /// Whether a national number has been entered.
  bool get hasNumber => number.isNotEmpty;

  /// Returns a copy with the given fields replaced.
  PhoneNumber copyWith({Country? country, String? number}) {
    return PhoneNumber(
      country: country ?? this.country,
      number: number ?? this.number,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber && other.country == country && other.number == number;

  @override
  int get hashCode => Object.hash(country, number);

  @override
  String toString() => 'PhoneNumber($completeNumber)';
}
