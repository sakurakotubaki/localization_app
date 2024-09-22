import 'package:flutter/material.dart';
import 'package:localization_app/i18n/strings.g.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.mainScreen.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t.mainScreen.title),
            const SizedBox(height: 20),
            // 言語選択ボタン
            ...AppLocale.values.map((locale) {
              return ElevatedButton(
                onPressed: () {
                  LocaleSettings.setLocale(locale);
                },
                child: Text(t.locales[locale.languageTag]!),
              );
            }),
          ],
        ),
      ),
    );
  }
}