import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'country_selector.dart';
import 'data/countries.dart';
import 'enums.dart';
import 'models/country.dart';
import 'models/phone_number.dart';
import 'theme/phone_input_theme.dart';
import 'widgets/country_flag.dart';
import 'widgets/country_list.dart';

/// A phone number input field with an integrated, searchable country-code
/// selector.
///
/// ### Theming
/// Pass a [theme] for a one-off look, set a [PhoneInputTheme] in your app's
/// [ThemeData.extensions] for global styling, or let the widget derive a theme
/// from the ambient [Brightness]. See [PhoneInputTheme].
///
/// ### Choosing which countries appear
/// * [customCountries] replaces the built-in dataset entirely.
/// * [countries] restricts to an allow-list of ISO codes.
/// * [excludeCountries] removes a deny-list of ISO codes.
/// * [favoriteCountries] pins ISO codes to the top of the selector.
///
/// ### Validation
/// The widget integrates with [Form]. Provide a [validator] (and optionally an
/// [autovalidateMode]), or drive the styling directly with [validationState] /
/// [errorText].
///
/// ```dart
/// PhoneNumberInput(
///   initialCountryCode: 'IN',
///   variant: PhoneFieldVariant.outlined,
///   selectorMode: CountrySelectorMode.bottomSheet,
///   excludeCountries: const ['KP', 'IR'],
///   favoriteCountries: const ['IN', 'US', 'GB'],
///   onChanged: (phone) => print(phone.completeNumber),
///   validator: (phone) =>
///       (phone == null || phone.number.length < 6) ? 'Enter a valid number' : null,
/// )
/// ```
class PhoneNumberInput extends StatefulWidget {
  /// Creates a phone number input field.
  const PhoneNumberInput({
    super.key,
    this.initialValue,
    this.initialCountryCode,
    this.onChanged,
    this.onCountryChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.variant = PhoneFieldVariant.outlined,
    this.borderRadius,
    this.theme,
    this.showFlag = true,
    this.showDialCode = true,
    this.flagBuilder,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validationState = PhoneValidationState.none,
    this.selectorMode = CountrySelectorMode.bottomSheet,
    this.selectorTitle,
    this.searchHint,
    this.popularLabel,
    this.allCountriesLabel,
    this.emptyLabel,
    this.showSearchBar = true,
    this.customCountries,
    this.countries,
    this.excludeCountries,
    this.favoriteCountries,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.keyboardType = TextInputType.phone,
    this.inputFormatters,
    this.controller,
  });

  /// Initial value (selects the country and pre-fills the number).
  final PhoneNumber? initialValue;

  /// Initial country by ISO code, used when [initialValue] is null.
  final String? initialCountryCode;

  /// Called whenever the country or number changes.
  final ValueChanged<PhoneNumber>? onChanged;

  /// Called when only the country changes.
  final ValueChanged<Country>? onCountryChanged;

  /// Validator integrated with [Form] / [FormState.validate].
  final FormFieldValidator<PhoneNumber>? validator;

  /// When/whether [validator] runs automatically.
  final AutovalidateMode autovalidateMode;

  /// Visual style of the input box.
  final PhoneFieldVariant variant;

  /// Overrides the box corner radius (ignored for [PhoneFieldVariant.pill]).
  final double? borderRadius;

  /// Per-widget theme override. Falls back to the [ThemeData] extension, then
  /// to a brightness-based default.
  final PhoneInputTheme? theme;

  /// Whether to show the flag on the country trigger.
  final bool showFlag;

  /// Whether to show the dial code on the country trigger.
  final bool showDialCode;

  /// Custom flag renderer (e.g. image flags for Android). See [CountryFlagBuilder].
  final CountryFlagBuilder? flagBuilder;

  /// Floating label text.
  final String? labelText;

  /// Placeholder text (defaults to "Phone number").
  final String? hintText;

  /// Helper text below the field.
  final String? helperText;

  /// External error text. Takes precedence over [validator] output.
  final String? errorText;

  /// Explicit validation state for styling. When not [PhoneValidationState.none]
  /// it overrides the state inferred from errors.
  final PhoneValidationState validationState;

  /// How the country selector is presented.
  final CountrySelectorMode selectorMode;

  /// Title of the selector surface (defaults to "Select country").
  final String? selectorTitle;

  /// Placeholder of the selector's search field.
  final String? searchHint;

  /// Header above the pinned favourites group (defaults to "Popular").
  /// Provide a translated string to localize the selector.
  final String? popularLabel;

  /// Header above the full country list (defaults to "All countries").
  /// Provide a translated string to localize the selector.
  final String? allCountriesLabel;

  /// Text shown when a search matches nothing (defaults to
  /// "No countries found"). Provide a translated string to localize.
  final String? emptyLabel;

  /// Whether the selector shows a search field.
  final bool showSearchBar;

  /// Replaces the built-in dataset entirely.
  final List<Country>? customCountries;

  /// Allow-list of ISO codes to show.
  final List<String>? countries;

  /// Deny-list of ISO codes to hide.
  final List<String>? excludeCountries;

  /// ISO codes pinned to the top of the selector (defaults to a popular set).
  final List<String>? favoriteCountries;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the number is read-only (the selector is also disabled).
  final bool readOnly;

  /// Whether the number field grabs focus on mount.
  final bool autofocus;

  /// External focus node for the number field.
  final FocusNode? focusNode;

  /// Keyboard action for the number field.
  final TextInputAction? textInputAction;

  /// Keyboard type for the number field (defaults to [TextInputType.phone]).
  final TextInputType keyboardType;

  /// Input formatters applied to the number field. When null, the field
  /// restricts input to digits only ([FilteringTextInputFormatter.digitsOnly]).
  ///
  /// Provide your own list to allow grouping/masking (e.g. spaces or dashes)
  /// or to cap the length. Note that [PhoneNumber.number] stores exactly what
  /// the field contains, so apply any post-processing you need on the value.
  final List<TextInputFormatter>? inputFormatters;

  /// External controller for the number field's text (digits only by default).
  final TextEditingController? controller;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late TextEditingController _numberController;
  late bool _ownsController;
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  late Country _country;

  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _link = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  double? _fieldWidth;
  bool _dropdownAbove = false;

  @override
  void initState() {
    super.initState();
    _numberController = widget.controller ??
        TextEditingController(text: widget.initialValue?.number ?? '');
    _ownsController = widget.controller == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _country = _resolveInitialCountry();
  }

  @override
  void didUpdateWidget(covariant PhoneNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) _numberController.dispose();
      _numberController =
          widget.controller ?? TextEditingController(text: _numberController.text);
      _ownsController = widget.controller == null;
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (_ownsFocusNode) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _ownsFocusNode = widget.focusNode == null;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _numberController.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  // ----- Country resolution -----

  List<Country> _effectiveCountries() {
    Iterable<Country> list = widget.customCountries ?? kCountries;
    if (widget.countries != null) {
      final Set<String> allow =
          widget.countries!.map((String e) => e.toUpperCase()).toSet();
      list = list.where((Country c) => allow.contains(c.isoCode));
    }
    if (widget.excludeCountries != null) {
      final Set<String> deny =
          widget.excludeCountries!.map((String e) => e.toUpperCase()).toSet();
      list = list.where((Country c) => !deny.contains(c.isoCode));
    }
    final List<Country> result = list.toList()
      ..sort((Country a, Country b) => a.name.compareTo(b.name));
    return result;
  }

  List<Country> _effectiveFavorites() {
    final List<Country> eff = _effectiveCountries();
    final Map<String, Country> byIso = <String, Country>{
      for (final Country c in eff) c.isoCode: c,
    };
    final List<String> isos = (widget.favoriteCountries ?? kDefaultFavoriteIso)
        .map((String e) => e.toUpperCase())
        .toList();
    final List<Country> favs = <Country>[];
    for (final String iso in isos) {
      final Country? c = byIso[iso];
      if (c != null) favs.add(c);
    }
    return favs;
  }

  Country _resolveInitialCountry() {
    final List<Country> eff = _effectiveCountries();
    final String? iso =
        widget.initialValue?.country.isoCode ?? widget.initialCountryCode;
    if (iso != null) {
      final Country? found = findCountryByIso(iso, source: eff);
      if (found != null) return found;
    }
    if (eff.isNotEmpty) return eff.first;
    return findCountryByIso('US') ?? kCountries.first;
  }

  // ----- Theme resolution -----

  PhoneInputTheme _resolveTheme(BuildContext context) {
    if (widget.theme != null) return widget.theme!;
    final PhoneInputTheme? ext = Theme.of(context).extension<PhoneInputTheme>();
    if (ext != null) return ext;
    return Theme.of(context).brightness == Brightness.dark
        ? PhoneInputTheme.dark()
        : PhoneInputTheme.light();
  }

  // ----- Value + change handling -----

  PhoneNumber _currentValue() =>
      PhoneNumber(country: _country, number: _numberController.text);

  void _selectCountry(Country c, FormFieldState<PhoneNumber> field) {
    setState(() => _country = c);
    final PhoneNumber value = _currentValue();
    field.didChange(value);
    widget.onCountryChanged?.call(c);
    widget.onChanged?.call(value);
  }

  void _handleNumberChanged(FormFieldState<PhoneNumber> field) {
    final PhoneNumber value = _currentValue();
    field.didChange(value);
    widget.onChanged?.call(value);
  }

  Future<void> _handleOpen(FormFieldState<PhoneNumber> field) async {
    if (!widget.enabled || widget.readOnly) return;
    final PhoneInputTheme t = _resolveTheme(context);
    if (widget.selectorMode == CountrySelectorMode.dropdown) {
      _toggleDropdown();
      return;
    }
    final Country? picked = await showCountrySelector(
      context: context,
      mode: widget.selectorMode,
      countries: _effectiveCountries(),
      favorites: _effectiveFavorites(),
      selected: _country,
      theme: t,
      title: widget.selectorTitle ?? 'Select country',
      searchHint: widget.searchHint ?? 'Search country or code',
      popularLabel: widget.popularLabel ?? 'Popular',
      allCountriesLabel: widget.allCountriesLabel ?? 'All countries',
      emptyLabel: widget.emptyLabel ?? 'No countries found',
      showSearch: widget.showSearchBar,
      flagBuilder: widget.flagBuilder,
    );
    if (picked != null && mounted) _selectCountry(picked, field);
  }

  void _toggleDropdown() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
      return;
    }
    final RenderBox? box =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final Offset topLeft = box.localToGlobal(Offset.zero);
      final Size screen = MediaQuery.of(context).size;
      final double spaceBelow = screen.height - (topLeft.dy + box.size.height);
      _fieldWidth = box.size.width;
      _dropdownAbove = spaceBelow < 280 && topLeft.dy > spaceBelow;
    }
    _overlayController.show();
  }

  // ----- Sub-widgets -----

  Widget _buildTrigger(PhoneInputTheme t, VoidCallback onTap) {
    final bool interactive = widget.enabled && !widget.readOnly;
    final double radius =
        widget.variant == PhoneFieldVariant.pill ? 999 : t.borderRadius;
    return InkWell(
      onTap: interactive ? onTap : null,
      borderRadius: BorderRadius.circular(radius),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.showFlag) ...<Widget>[
              CountryFlag(country: _country, size: 22, builder: widget.flagBuilder),
              const SizedBox(width: 6),
            ],
            if (widget.showDialCode) ...<Widget>[
              Text(
                _country.displayDialCode,
                style: t.dialCodeTextStyle.copyWith(color: t.textColor),
              ),
              const SizedBox(width: 2),
            ],
            Icon(Icons.arrow_drop_down, color: t.iconColor, size: 22),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(
    PhoneInputTheme t,
    PhoneValidationState state,
    String? errorText,
    Widget trigger,
  ) {
    final double radius = widget.borderRadius ??
        (widget.variant == PhoneFieldVariant.pill ? 999 : t.borderRadius);
    final bool filled = widget.variant == PhoneFieldVariant.filled;

    final Color idle = state == PhoneValidationState.valid
        ? t.successColor
        : state == PhoneValidationState.error
            ? t.errorColor
            : t.borderColor;
    final Color focus = state == PhoneValidationState.error
        ? t.errorColor
        : state == PhoneValidationState.valid
            ? t.successColor
            : t.focusedBorderColor;

    InputBorder make(Color color, double width) {
      if (widget.variant == PhoneFieldVariant.underline) {
        return UnderlineInputBorder(borderSide: BorderSide(color: color, width: width));
      }
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final Color restColor = filled ? Colors.transparent : idle;

    return InputDecoration(
      filled: filled,
      fillColor: filled ? t.fillColor : null,
      contentPadding: t.contentPadding,
      hintText: widget.hintText ?? 'Phone number',
      hintStyle: t.hintTextStyle.copyWith(color: t.hintColor),
      labelText: widget.labelText,
      labelStyle: t.labelTextStyle.copyWith(color: t.labelColor),
      floatingLabelStyle: t.labelTextStyle.copyWith(color: focus),
      helperText: widget.helperText,
      helperStyle: t.helperTextStyle.copyWith(color: t.hintColor),
      errorText: errorText,
      errorStyle: t.errorTextStyle.copyWith(color: t.errorColor),
      prefixIcon: trigger,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      enabledBorder: make(restColor, t.borderWidth),
      focusedBorder: make(focus, t.focusedBorderWidth),
      errorBorder: make(t.errorColor, t.borderWidth),
      focusedErrorBorder: make(t.errorColor, t.focusedBorderWidth),
      disabledBorder: make(
        filled ? Colors.transparent : t.borderColor,
        t.borderWidth,
      ),
      border: make(restColor, t.borderWidth),
    );
  }

  Widget _buildDropdownOverlay(PhoneInputTheme t, FormFieldState<PhoneNumber> field) {
    final double width = _fieldWidth ?? 320;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _overlayController.hide(),
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor:
              _dropdownAbove ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor:
              _dropdownAbove ? Alignment.bottomLeft : Alignment.topLeft,
          offset: Offset(0, _dropdownAbove ? -6 : 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: Material(
                elevation: 8,
                color: t.surfaceColor,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: CountryList(
                    countries: _effectiveCountries(),
                    favorites: _effectiveFavorites(),
                    selected: _country,
                    theme: t,
                    shrinkWrap: true,
                    showSearch: widget.showSearchBar,
                    flagBuilder: widget.flagBuilder,
                    searchHint: widget.searchHint ?? 'Search country or code',
                    popularLabel: widget.popularLabel ?? 'Popular',
                    allCountriesLabel:
                        widget.allCountriesLabel ?? 'All countries',
                    emptyLabel: widget.emptyLabel ?? 'No countries found',
                    onSelected: (Country c) {
                      _selectCountry(c, field);
                      _overlayController.hide();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final PhoneInputTheme t = _resolveTheme(context);
    return FormField<PhoneNumber>(
      initialValue: _currentValue(),
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      builder: (FormFieldState<PhoneNumber> field) {
        final String? error = widget.errorText ?? field.errorText;
        final PhoneValidationState state =
            widget.validationState != PhoneValidationState.none
                ? widget.validationState
                : (error != null
                    ? PhoneValidationState.error
                    : PhoneValidationState.none);

        final Widget trigger = _buildTrigger(t, () => _handleOpen(field));
        final InputDecoration decoration =
            _buildDecoration(t, state, error, trigger);

        final Widget textField = TextField(
          controller: _numberController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters ??
              <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          style: t.inputTextStyle
              .copyWith(color: widget.enabled ? t.textColor : t.hintColor),
          cursorColor: t.focusedBorderColor,
          decoration: decoration,
          onChanged: (_) => _handleNumberChanged(field),
          onTap: () {
            if (widget.selectorMode == CountrySelectorMode.dropdown &&
                _overlayController.isShowing) {
              _overlayController.hide();
            }
          },
        );

        final Widget anchored = CompositedTransformTarget(
          link: _link,
          child: SizedBox(key: _fieldKey, child: textField),
        );

        if (widget.selectorMode == CountrySelectorMode.dropdown) {
          return OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (BuildContext ctx) =>
                _buildDropdownOverlay(t, field),
            child: anchored,
          );
        }
        return anchored;
      },
    );
  }
}
