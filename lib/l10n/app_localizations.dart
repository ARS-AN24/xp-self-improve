import 'strings_en.dart';
import 'strings_ru.dart';

class AppLocalizations {
  final String language;

  const AppLocalizations(this.language);

  String get(String key) {
    final values = language == 'ru'
        ? RussianStrings.values
        : EnglishStrings.values;

    return values[key] ?? key;
  }

  bool get isRussian => language == 'ru';

  bool get isEnglish => language == 'en';

  static const supportedLanguages = [
    'en',
    'ru',
  ];
}