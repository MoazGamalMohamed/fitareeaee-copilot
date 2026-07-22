import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const Map<String, String> en = {
    'app_name': 'Fitareeaee',
    'home_plan_title': 'Plan your next trip',
    'home_plan_subtitle':
        'Request a ride or delivery, or offer one to the community.',
    'home_question': 'What would you like to do?',
    'home_request': 'Request a ride or delivery',
    'home_request_subtitle':
        'Ride or send a package and pay after choosing a match.',
    'home_offer': 'Offer a ride or delivery',
    'home_offer_subtitle':
        'Drive or deliver and receive payment after completion.',
    'home_explore': 'Explore the marketplace',
    'home_explore_subtitle': 'Browse available offers and open requests.',
    'home_quick_links': 'Quick Links',
    'home_matches': 'Matches',
    'home_past': 'Past Trips',
    'home_payments': 'Payments',
    'home_support': 'Support',
    'home_nav_home': 'Home',
    'home_nav_trips': 'Trips',
    'home_nav_chat': 'Chat',
    'home_nav_profile': 'Profile',
    'home_plan_ai': 'Plan with\nGPT-5.6',
    'settings_title': 'Settings',
    'settings_preferences': 'Preferences',
    'settings_app_language': 'App language',
    'settings_app_language_help': 'Changes the interface and text direction',
    'settings_planning_languages': 'Planning and voice languages',
    'settings_planning_languages_help':
        'Select the languages GPT-5.6 should expect',
    'settings_english': 'English',
    'settings_arabic': 'Arabic',
    'settings_currency': 'Currency',
    'settings_currency_help': 'Display prices in your preferred currency',
    'settings_currency_note':
        'Trip amounts are stored in USD. AED and SAR use their official USD pegs.',
    'common_saved': 'Saved',
  };

  static const Map<String, String> ar = {
    'app_name': 'فتاريعي',
    'home_plan_title': 'خطط لرحلتك القادمة',
    'home_plan_subtitle': 'اطلب رحلة أو توصيلاً، أو قدم عرضاً للمجتمع.',
    'home_question': 'ماذا تريد أن تفعل؟',
    'home_request': 'اطلب رحلة أو توصيلاً',
    'home_request_subtitle': 'اركب أو أرسل طرداً وادفع بعد اختيار العرض.',
    'home_offer': 'قدم رحلة أو توصيلاً',
    'home_offer_subtitle':
        'قد السيارة أو سلّم الطرد واستلم المبلغ بعد الإكمال.',
    'home_explore': 'استكشف السوق',
    'home_explore_subtitle': 'تصفح العروض والطلبات المتاحة.',
    'home_quick_links': 'روابط سريعة',
    'home_matches': 'المطابقات',
    'home_past': 'الرحلات السابقة',
    'home_payments': 'المدفوعات',
    'home_support': 'الدعم',
    'home_nav_home': 'الرئيسية',
    'home_nav_trips': 'الرحلات',
    'home_nav_chat': 'المحادثات',
    'home_nav_profile': 'الملف الشخصي',
    'home_plan_ai': 'خطط باستخدام\nGPT-5.6',
    'settings_title': 'الإعدادات',
    'settings_preferences': 'التفضيلات',
    'settings_app_language': 'لغة التطبيق',
    'settings_app_language_help': 'تغيير الواجهة واتجاه النص',
    'settings_planning_languages': 'لغات التخطيط والصوت',
    'settings_planning_languages_help': 'حدد اللغات التي يتوقعها GPT-5.6',
    'settings_english': 'الإنجليزية',
    'settings_arabic': 'العربية',
    'settings_currency': 'العملة',
    'settings_currency_help': 'عرض الأسعار بالعملة المفضلة',
    'settings_currency_note':
        'تُحفظ مبالغ الرحلات بالدولار. يستخدم الدرهم والريال سعر الربط الرسمي بالدولار.',
    'common_saved': 'تم الحفظ',
  };

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      AppLocalizations(Localizations.localeOf(context));

  String text(String key) {
    final values = locale.languageCode == 'ar' ? ar : en;
    return values[key] ?? en[key] ?? key;
  }

  static String getString(String key, [Locale? locale]) =>
      AppLocalizations(locale ?? const Locale('en')).text(key);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ar';

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationContext on BuildContext {
  String tr(String key) => AppLocalizations.of(this).text(key);
}
