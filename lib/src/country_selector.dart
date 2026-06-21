import 'package:flutter/material.dart';

import 'enums.dart';
import 'models/country.dart';
import 'theme/phone_input_theme.dart';
import 'widgets/country_flag.dart';
import 'widgets/country_list.dart';

Widget _titleBar(BuildContext context, String title, PhoneInputTheme t) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: t.surfaceTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: t.surfaceMutedColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

/// Presents the country selector using [mode] and resolves with the chosen
/// [Country], or `null` if dismissed.
///
/// Handles the [CountrySelectorMode.bottomSheet], [CountrySelectorMode.dialog]
/// and [CountrySelectorMode.fullScreen] surfaces. The
/// [CountrySelectorMode.dropdown] surface is rendered inline by
/// [PhoneNumberInput] itself and is treated here as a bottom sheet if called
/// directly.
Future<Country?> showCountrySelector({
  required BuildContext context,
  required CountrySelectorMode mode,
  required List<Country> countries,
  required PhoneInputTheme theme,
  List<Country> favorites = const <Country>[],
  Country? selected,
  String title = 'Select country',
  String searchHint = 'Search country or code',
  String popularLabel = 'Popular',
  String allCountriesLabel = 'All countries',
  String emptyLabel = 'No countries found',
  bool showSearch = true,
  CountryFlagBuilder? flagBuilder,
}) {
  Widget buildList(BuildContext ctx, {bool autofocus = false}) {
    return CountryList(
      countries: countries,
      favorites: favorites,
      selected: selected,
      theme: theme,
      showSearch: showSearch,
      autofocusSearch: autofocus,
      flagBuilder: flagBuilder,
      searchHint: searchHint,
      popularLabel: popularLabel,
      allCountriesLabel: allCountriesLabel,
      emptyLabel: emptyLabel,
      onSelected: (Country c) => Navigator.of(ctx).pop(c),
    );
  }

  switch (mode) {
    case CountrySelectorMode.fullScreen:
      return Navigator.of(context).push<Country>(
        MaterialPageRoute<Country>(
          fullscreenDialog: true,
          builder: (BuildContext ctx) => Scaffold(
            backgroundColor: theme.surfaceColor,
            appBar: AppBar(
              backgroundColor: theme.surfaceColor,
              foregroundColor: theme.surfaceTextColor,
              elevation: 0,
              scrolledUnderElevation: 0.5,
              title: Text(
                title,
                style: TextStyle(
                  color: theme.surfaceTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.close, color: theme.surfaceTextColor),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            body: SafeArea(top: false, child: buildList(ctx)),
          ),
        ),
      );

    case CountrySelectorMode.dialog:
      return showDialog<Country>(
        context: context,
        barrierColor: theme.scrimColor,
        builder: (BuildContext ctx) {
          final Size size = MediaQuery.of(ctx).size;
          return Dialog(
            backgroundColor: theme.surfaceColor,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SizedBox(
              width: 420,
              height: size.height * 0.7,
              child: Column(
                children: <Widget>[
                  _titleBar(ctx, title, theme),
                  Divider(height: 1, color: theme.dividerColor),
                  Expanded(child: buildList(ctx)),
                ],
              ),
            ),
          );
        },
      );

    case CountrySelectorMode.bottomSheet:
    case CountrySelectorMode.dropdown:
      return showModalBottomSheet<Country>(
        context: context,
        isScrollControlled: true,
        backgroundColor: theme.surfaceColor,
        barrierColor: theme.scrimColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext ctx) {
          final MediaQueryData media = MediaQuery.of(ctx);
          return Padding(
            padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
            child: SizedBox(
              height: media.size.height * 0.85,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dragHandleColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  _titleBar(ctx, title, theme),
                  Divider(height: 1, color: theme.dividerColor),
                  Expanded(child: buildList(ctx)),
                ],
              ),
            ),
          );
        },
      );
  }
}
