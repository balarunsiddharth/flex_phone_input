import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_country_picker/phone_country_picker.dart';

void main() {
  group('Country', () {
    test('derives a flag emoji from the ISO code', () {
      const Country india = Country(name: 'India', isoCode: 'IN', dialCode: '91');
      // 🇮🇳 = U+1F1EE U+1F1F3
      expect(india.flagEmoji, '\u{1F1EE}\u{1F1F3}');
      expect(india.displayDialCode, '+91');
    });

    test('equality is based on iso, dial code and name', () {
      const Country a = Country(name: 'India', isoCode: 'IN', dialCode: '91');
      const Country b = Country(name: 'India', isoCode: 'IN', dialCode: '91');
      expect(a, equals(b));
    });
  });

  group('PhoneNumber', () {
    test('builds an E.164-style complete number', () {
      const Country india = Country(name: 'India', isoCode: 'IN', dialCode: '91');
      const PhoneNumber phone = PhoneNumber(country: india, number: '9876543210');
      expect(phone.completeNumber, '+919876543210');
      expect(phone.e164, '+919876543210');
      expect(phone.hasNumber, isTrue);
    });
  });

  group('dataset', () {
    test('ships a non-empty country list and lookups work', () {
      expect(kCountries, isNotEmpty);
      expect(findCountryByIso('in')?.isoCode, 'IN');
      expect(findCountryByIso('ZZ'), isNull);
    });
  });

  group('PhoneInputTheme', () {
    test('lerp returns a blended theme', () {
      final PhoneInputTheme light = PhoneInputTheme.light();
      final PhoneInputTheme dark = PhoneInputTheme.dark();
      final PhoneInputTheme mid = light.lerp(dark, 0.5);
      expect(mid, isA<PhoneInputTheme>());
    });
  });

  testWidgets('PhoneNumberInput renders and accepts digits', (WidgetTester tester) async {
    PhoneNumber? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneNumberInput(
            initialCountryCode: 'IN',
            onChanged: (PhoneNumber v) => captured = v,
          ),
        ),
      ),
    );

    expect(find.byType(PhoneNumberInput), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.pump();

    expect(captured, isNotNull);
    expect(captured!.completeNumber, '+919876543210');
  });
}
