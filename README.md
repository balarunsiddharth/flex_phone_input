# phone_country_picker

A searchable **phone number input** field with an integrated **country code picker** for Flutter.

- 🎨 **Fully themeable** — style every color, border, radius and text style via a `ThemeExtension`. Apply it globally, per-widget, or derive it from your app's `ColorScheme`.
- 🌍 **Country control** — show only the countries you want, hide specific ones, pin favourites, or supply your own dataset.
- 🧩 **Four field styles** — `outlined`, `filled`, `pill`, `underline`.
- 🪟 **Four selector surfaces** — bottom sheet, dialog, full-screen page, and an inline dropdown, all sharing one searchable list.
- ✅ **Validation** — integrates with `Form`, or drive the state directly.

## Installation

```yaml
dependencies:
  phone_country_picker: ^1.0.0
```

```dart
import 'package:phone_country_picker/phone_country_picker.dart';
```

## Quick start

```dart
PhoneNumberInput(
  initialCountryCode: 'IN',
  labelText: 'Phone number',
  onChanged: (PhoneNumber phone) {
    print(phone.completeNumber); // e.g. +919876543210
    print(phone.country.isoCode); // IN
    print(phone.number);          // 9876543210
  },
)
```

`onChanged` gives you a `PhoneNumber` with the selected `country` and the national `number` (digits only). Use `completeNumber` / `e164` for the full `+<dial><number>` string.

## Theming

Everything visual lives in `PhoneInputTheme`, a `ThemeExtension`. There are three ways to apply it, from broadest to most specific.

**1. Globally**, on your `ThemeData` — every field in the app picks it up, including light/dark:

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[PhoneInputTheme.light()],
  ),
  darkTheme: ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[PhoneInputTheme.dark()],
  ),
);
```

**2. Derived from your `ColorScheme`**, so it automatically matches your brand:

```dart
extensions: <ThemeExtension<dynamic>>[
  PhoneInputTheme.fromColorScheme(Theme.of(context).colorScheme),
],
```

**3. Per-widget**, overriding just what you need with `copyWith`:

```dart
PhoneNumberInput(
  theme: PhoneInputTheme.light().copyWith(
    focusedBorderColor: Colors.deepPurple,
    borderRadius: 14,
    fillColor: const Color(0xFFF5F3FF),
  ),
)
```

If you don't pass a theme and haven't registered one on `ThemeData`, the widget falls back to `PhoneInputTheme.light()` / `.dark()` based on the ambient brightness.

A few of the tokens you can set: `fillColor`, `textColor`, `hintColor`, `labelColor`, `borderColor`, `focusedBorderColor`, `errorColor`, `successColor`, `borderRadius`, `borderWidth`, `contentPadding`, the six text styles (`inputTextStyle`, `hintTextStyle`, `dialCodeTextStyle`, …), and the selector-surface colors (`surfaceColor`, `selectedTileColor`, `searchFillColor`, `dragHandleColor`, `scrimColor`, …).

## Choosing which countries appear

Restrict to an **allow-list** (only these show):

```dart
PhoneNumberInput(
  countries: const <String>['IN', 'US', 'GB', 'AE', 'SG'],
)
```

**Hide** specific countries (everything else shows):

```dart
PhoneNumberInput(
  excludeCountries: const <String>['KP', 'IR', 'SY'],
)
```

**Pin favourites** to the top of the selector:

```dart
PhoneNumberInput(
  favoriteCountries: const <String>['IN', 'US', 'GB'],
)
```

Supply a **fully custom dataset** (ignores the built-in list entirely):

```dart
PhoneNumberInput(
  customCountries: const <Country>[
    Country(name: 'India', isoCode: 'IN', dialCode: '91'),
    Country(name: 'Singapore', isoCode: 'SG', dialCode: '65'),
  ],
)
```

All four can be combined; favourites are always intersected with whatever set is effective.

## Field styles

```dart
PhoneNumberInput(variant: PhoneFieldVariant.outlined)  // default
PhoneNumberInput(variant: PhoneFieldVariant.filled)
PhoneNumberInput(variant: PhoneFieldVariant.pill)
PhoneNumberInput(variant: PhoneFieldVariant.underline)
```

Toggle the trigger contents with `showFlag` and `showDialCode`.

## Selector surfaces

```dart
PhoneNumberInput(selectorMode: CountrySelectorMode.bottomSheet) // default
PhoneNumberInput(selectorMode: CountrySelectorMode.dialog)
PhoneNumberInput(selectorMode: CountrySelectorMode.fullScreen)
PhoneNumberInput(selectorMode: CountrySelectorMode.dropdown)    // inline, good on desktop/web
```

## Validation

Integrate with `Form`:

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: PhoneNumberInput(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (PhoneNumber? value) {
      if (value == null || value.number.length < 6) return 'Enter a valid number';
      return null;
    },
  ),
);

// later:
if (formKey.currentState!.validate()) { /* submit */ }
```

Or drive the styling yourself with `validationState` + `errorText`/`helperText`.

## Flags on Android

Emoji flags render inconsistently on some Android devices. To use image flags, pass a `flagBuilder` (e.g. with the `country_flags` package) — it's used everywhere flags appear:

```dart
PhoneNumberInput(
  flagBuilder: (context, country, size) =>
      CountryFlag.fromCountryCode(country.isoCode, height: size, width: size * 1.4),
)
```

## Notes

- The built-in dataset has 175 countries. Calling codes are shared for some regions (`+1`, `+7`), so the package stores the selected `Country` rather than inferring it from digits.
- The number field accepts digits only; wrap or post-process if you need custom formatting.

## License

MIT — see [LICENSE](LICENSE).
