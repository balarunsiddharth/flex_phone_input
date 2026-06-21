/// The visual treatment of the phone field's input box.
enum PhoneFieldVariant {
  /// A box with a visible 1px border on all sides (default).
  outlined,

  /// A filled box (tinted background) with no resting border.
  filled,

  /// A fully rounded ("stadium") outlined box.
  pill,

  /// A single bottom underline (Material text-field style).
  underline,
}

/// How the country selector surface is presented when the trigger is tapped.
enum CountrySelectorMode {
  /// Slides up from the bottom (default). Great for mobile.
  bottomSheet,

  /// A centered modal dialog.
  dialog,

  /// A full-screen page (pushed route).
  fullScreen,

  /// An inline popover anchored to the field. Best for wide/desktop layouts.
  dropdown,
}

/// Drives the field's accent color and which helper/error text is shown.
enum PhoneValidationState {
  /// Neutral — no validation styling.
  none,

  /// Valid — uses the theme's success color.
  valid,

  /// Invalid — uses the theme's error color and shows the error text.
  error,
}
