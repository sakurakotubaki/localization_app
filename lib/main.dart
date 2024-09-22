import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_app/i18n/strings.g.dart';
import 'package:localization_app/settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // initialize with the right locale
  runApp(TranslationProvider(
    // wrap with TranslationProvider
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      // error GlobalMaterialLocalizations
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    LocaleSettings.getLocaleStream().listen((event) {
      print('locale changed: $event');
    });
  }

  @override
  Widget build(BuildContext context) {
    // get t variable, will trigger rebuild on locale change
    // otherwise just call t directly (if locale is not changeable)
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        // change language
        actions: [
          PopupMenuButton<AppLocale>(
            icon: const Icon(Icons.language),
            onSelected: (AppLocale locale) {
              LocaleSettings.setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return AppLocale.values.map((AppLocale locale) {
                return PopupMenuItem<AppLocale>(
                  value: locale,
                  child: Text(t.locales[locale.languageTag]!),
                );
              }).toList();
            },
          ),
        ],
        title: Text(t.mainScreen.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // error mainScreen
            Text(t.mainScreen.counter(n: _counter)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              // lets loop over all supported locales
              children: AppLocale.values.map((locale) {
                // active locale
                AppLocale activeLocale = LocaleSettings.currentLocale;

                // typed version is preferred to avoid typos
                bool active = activeLocale == locale;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: active ? Colors.blue.shade100 : null,
                    ),
                    onPressed: () {
                      // locale change, will trigger a rebuild (no setState needed)
                      LocaleSettings.setLocale(locale);
                    },
                    // error mainScreen
                    child: Text(t.locales[locale.languageTag]!),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage())
              );
            }, child: const Text('next')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _counter++);
        },
        // error mainScreen
        tooltip: context.t.mainScreen.tapMe, // using extension method
        child: const Icon(Icons.add),
      ),
    );
  }
}
