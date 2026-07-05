# Screenshots

Images in this folder are displayed on the package's [pub.dev](https://pub.dev/packages/flex_phone_input) page.

## How to use

1. Add image files here. Suggested names (matching the commented block in `../pubspec.yaml`):
   - `picker_open.png` — country picker open with the searchable list
   - `field_variants.png` — the four field styles (outlined, filled, pill, underline)
   - `selector_surfaces.png` — bottom sheet, dialog, full screen, dropdown
   - `dark_mode.png` — light/dark theming
   - `validation.png` — inline validation / error state
2. In `../pubspec.yaml`, uncomment the `screenshots:` entries whose files now exist.
3. Bump the version, update `CHANGELOG.md`, and run `dart pub publish`.

## Rules

- Formats: `png`, `jpg`, `webp`, `gif` (animated gif allowed).
- Each file must be **under 4 MB** — they are bundled into the published archive.
- The **first** entry in `screenshots:` becomes the page thumbnail.
- Every entry needs a `description` (used as the caption / alt text).
