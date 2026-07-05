import 'package:flutter/material.dart';
import 'package:phone_country_picker/phone_country_picker.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggle() => setState(
        () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );

  @override
  Widget build(BuildContext context) {
    const Color seed = Color(0xFF1A56DB);
    return MaterialApp(
      title: 'phone_country_picker demo',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      // Theming, way #1: register PhoneInputTheme globally for light + dark.
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: seed,
        extensions: <ThemeExtension<dynamic>>[PhoneInputTheme.light()],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: seed,
        extensions: <ThemeExtension<dynamic>>[PhoneInputTheme.dark()],
      ),
      home: DemoPage(isDark: _mode == ThemeMode.dark, onToggleTheme: _toggle),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key, required this.isDark, required this.onToggleTheme});

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber? _latest;

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('phone_country_picker'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: <Widget>[
            Text(
              _latest == null ? 'Type a number below…' : 'Value: ${_latest!.completeNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            _section('Field styles'),
            PhoneNumberInput(
              initialCountryCode: 'IN',
              variant: PhoneFieldVariant.outlined,
              labelText: 'Outlined',
              onChanged: (PhoneNumber v) => setState(() => _latest = v),
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'US',
              variant: PhoneFieldVariant.filled,
              hintText: 'Filled',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'GB',
              variant: PhoneFieldVariant.pill,
              hintText: 'Pill',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'AE',
              variant: PhoneFieldVariant.underline,
              hintText: 'Underline',
            ),

            _section('Selector surfaces'),
            const PhoneNumberInput(
              initialCountryCode: 'SG',
              selectorMode: CountrySelectorMode.bottomSheet,
              hintText: 'Bottom sheet (tap the flag)',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'AU',
              selectorMode: CountrySelectorMode.dialog,
              hintText: 'Dialog',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'JP',
              selectorMode: CountrySelectorMode.fullScreen,
              hintText: 'Full screen',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              initialCountryCode: 'DE',
              selectorMode: CountrySelectorMode.dropdown,
              hintText: 'Inline dropdown',
            ),

            _section('Country control'),
            const PhoneNumberInput(
              countries: <String>['IN', 'US', 'GB', 'AE', 'SG'],
              initialCountryCode: 'IN',
              hintText: 'Allow-list: only 5 countries',
            ),
            const SizedBox(height: 14),
            const PhoneNumberInput(
              excludeCountries: <String>['KP', 'IR', 'SY'],
              favoriteCountries: <String>['IN', 'US', 'GB'],
              hintText: 'Exclude a few + custom favourites',
            ),

            _section('Per-widget theme override'),
            PhoneNumberInput(
              initialCountryCode: 'FR',
              hintText: 'Custom purple theme',
              theme: (widget.isDark ? PhoneInputTheme.dark() : PhoneInputTheme.light())
                  .copyWith(
                focusedBorderColor: const Color(0xFF7C3AED),
                selectedTileColor: const Color(0x337C3AED),
                borderRadius: 16,
              ),
            ),

            _section('Validation (Form)'),
            Form(
              key: _formKey,
              child: PhoneNumberInput(
                initialCountryCode: 'IN',
                labelText: 'Required, min 6 digits',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (PhoneNumber? value) {
                  if (value == null || value.number.length < 6) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final bool ok = _formKey.currentState?.validate() ?? false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'Valid!' : 'Please fix the field')),
                );
              },
              child: const Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }
}
