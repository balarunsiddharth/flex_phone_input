import 'package:flutter/material.dart';

import '../models/country.dart';
import '../theme/phone_input_theme.dart';
import 'country_flag.dart';

class _Entry {
  const _Entry.header(this.header) : country = null;
  const _Entry.country(this.country) : header = null;
  final String? header;
  final Country? country;
  bool get isHeader => header != null;
}

/// A searchable list of countries with an optional pinned "popular" group.
///
/// This is the pure presentation widget shared by every selector surface
/// (bottom sheet, dialog, full-screen page, dropdown). You can also drop it
/// into your own custom surface.
class CountryList extends StatefulWidget {
  /// Creates a searchable country list.
  const CountryList({
    super.key,
    required this.countries,
    required this.theme,
    this.favorites = const <Country>[],
    this.selected,
    required this.onSelected,
    this.showSearch = true,
    this.shrinkWrap = false,
    this.autofocusSearch = false,
    this.flagBuilder,
    this.searchHint = 'Search country or code',
    this.popularLabel = 'Popular',
    this.allCountriesLabel = 'All countries',
    this.emptyLabel = 'No countries found',
  });

  /// All selectable countries (already filtered/ordered by the caller).
  final List<Country> countries;

  /// Countries pinned at the top under [popularLabel] (only while not searching).
  final List<Country> favorites;

  /// The currently selected country, highlighted with a check.
  final Country? selected;

  /// Called when the user taps a country.
  final ValueChanged<Country> onSelected;

  /// Theme tokens for colors and text styles.
  final PhoneInputTheme theme;

  /// Whether to show the search field.
  final bool showSearch;

  /// When true, the inner list shrink-wraps its content (used by the dropdown).
  final bool shrinkWrap;

  /// Whether the search field grabs focus on open.
  final bool autofocusSearch;

  /// Optional custom flag renderer.
  final CountryFlagBuilder? flagBuilder;

  /// Placeholder for the search field.
  final String searchHint;

  /// Header label for the pinned group.
  final String popularLabel;

  /// Header label for the full list.
  final String allCountriesLabel;

  /// Text shown when a search matches nothing.
  final String emptyLabel;

  @override
  State<CountryList> createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(Country c, String q) {
    if (c.name.toLowerCase().contains(q)) return true;
    if (c.isoCode.toLowerCase().contains(q)) return true;
    final String digits = q.replaceAll('+', '').trim();
    if (digits.isNotEmpty && c.dialCode.startsWith(digits)) return true;
    return false;
  }

  List<_Entry> _buildEntries() {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      final List<_Entry> entries = <_Entry>[];
      if (widget.favorites.isNotEmpty) {
        entries.add(_Entry.header(widget.popularLabel));
        entries.addAll(widget.favorites.map(_Entry.country));
        entries.add(_Entry.header(widget.allCountriesLabel));
      }
      entries.addAll(widget.countries.map(_Entry.country));
      return entries;
    }
    return widget.countries
        .where((Country c) => _matches(c, q))
        .map(_Entry.country)
        .toList();
  }

  Widget _searchField(PhoneInputTheme t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchController,
        autofocus: widget.autofocusSearch,
        style: t.inputTextStyle.copyWith(color: t.surfaceTextColor, fontSize: 15),
        cursorColor: t.focusedBorderColor,
        onChanged: (String v) => setState(() => _query = v),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: t.searchFillColor,
          hintText: widget.searchHint,
          hintStyle: t.hintTextStyle.copyWith(color: t.surfaceMutedColor, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: t.surfaceMutedColor, size: 20),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close, color: t.surfaceMutedColor, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: t.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: t.focusedBorderColor, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _header(String label, PhoneInputTheme t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: t.sectionHeaderColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _row(Country c, PhoneInputTheme t) {
    final bool isSelected = widget.selected == c;
    return Material(
      color: isSelected ? t.selectedTileColor : Colors.transparent,
      child: InkWell(
        onTap: () => widget.onSelected(c),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              CountryFlag(country: c, size: 24, builder: widget.flagBuilder),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.surfaceTextColor,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                c.displayDialCode,
                style: TextStyle(color: t.surfaceMutedColor, fontSize: 14),
              ),
              if (isSelected) ...<Widget>[
                const SizedBox(width: 10),
                Icon(Icons.check, color: t.focusedBorderColor, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PhoneInputTheme t = widget.theme;
    final List<_Entry> entries = _buildEntries();

    Widget content;
    if (entries.isEmpty) {
      final Widget empty = Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Text(
            widget.emptyLabel,
            style: TextStyle(color: t.surfaceMutedColor, fontSize: 14),
          ),
        ),
      );
      content = widget.shrinkWrap ? empty : Expanded(child: empty);
    } else {
      final Widget listView = ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        padding: const EdgeInsets.only(bottom: 8),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          final _Entry e = entries[index];
          return e.isHeader ? _header(e.header!, t) : _row(e.country!, t);
        },
      );
      content = widget.shrinkWrap ? Flexible(child: listView) : Expanded(child: listView);
    }

    return Column(
      mainAxisSize: widget.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      children: <Widget>[
        if (widget.showSearch) _searchField(t),
        content,
      ],
    );
  }
}
