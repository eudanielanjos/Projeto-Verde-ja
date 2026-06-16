// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get idiomasTitle => 'LANGUAGES';

  @override
  String get idiomasSubtitle =>
      'Select the main language to navigate the application.';

  @override
  String get portugues => 'Portuguese (Brazil)';

  @override
  String get english => 'English (United States)';

  @override
  String get espanol => 'Spanish (Spain)';

  @override
  String get francais => 'French (France)';
}
