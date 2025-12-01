import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_and_local_state.dart';

class ThemeAndLocalCubit extends Cubit<ThemeAndLocalState> {
  ThemeAndLocalCubit() : super(const ThemeAndLocalState());

  /// تحميل القيم المخزنة أول ما يفتح التطبيق
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final locale = prefs.getString('locale') ?? 'en';
    final theme = prefs.getString('theme') ?? 'blue'; // تحميل الثيم المخزن

    emit(ThemeAndLocalState(isDark: isDark, locale: locale, theme: theme));
  }

  /// تبديل الثيم (داكن/فاتح)
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = !state.isDark;
    await prefs.setBool('isDark', newTheme);

    emit(state.copyWith(isDark: newTheme));
  }

  /// تغيير اللغة
  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);

    emit(state.copyWith(locale: langCode));
  }

  /// تغيير الثيم الملون
  Future<void> changeTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);

    emit(state.copyWith(theme: theme));
  }
}