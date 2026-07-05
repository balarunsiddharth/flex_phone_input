/// A searchable phone number input field with an integrated, fully themeable
/// country-code picker.
///
/// Import this single file to access everything:
///
/// ```dart
/// import 'package:phone_country_picker/phone_country_picker.dart';
/// ```
library;

export 'src/country_selector.dart' show showCountrySelector;
export 'src/data/countries.dart'
    show kCountries, kDefaultFavoriteIso, findCountryByIso, findCountryByDialCode;
export 'src/enums.dart';
export 'src/models/country.dart';
export 'src/models/phone_number.dart';
export 'src/phone_number_input.dart';
export 'src/theme/phone_input_theme.dart';
export 'src/widgets/country_flag.dart';
export 'src/widgets/country_list.dart';
