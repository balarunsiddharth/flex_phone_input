## 1.0.1

- Add screenshots to the pub.dev package page.
- Point repository / homepage / issue tracker links at the renamed repository.

## 1.0.0

Initial release.

- `PhoneNumberInput` field with an integrated, searchable country-code selector.
- Four field styles: `outlined`, `filled`, `pill`, `underline`.
- Four selector surfaces: `bottomSheet`, `dialog`, `fullScreen`, inline `dropdown` — all sharing one searchable list.
- Full theming via `PhoneInputTheme` (a `ThemeExtension`): apply globally, per-widget, or derive from a `ColorScheme`.
- Country control: allow-list (`countries`), deny-list (`excludeCountries`), pinned favourites (`favoriteCountries`), or a fully custom dataset (`customCountries`).
- `Form` integration via `validator` / `autovalidateMode`, plus explicit `validationState` / `errorText`.
- 175 built-in countries with ISO-derived flag emojis and a `flagBuilder` hook for image flags.
- Localizable selector labels: `popularLabel`, `allCountriesLabel`, `emptyLabel` (alongside `selectorTitle` / `searchHint`).
- Customizable number-field input: `keyboardType` and `inputFormatters` (defaults to digits-only when omitted).
