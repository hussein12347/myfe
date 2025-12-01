part of 'theme_and_local_cubit.dart';

@immutable
class ThemeAndLocalState {
  final bool isDark;
  final String locale;
  final String theme; // حقل جديد لتتبع الثيم المختار

  const ThemeAndLocalState({
    this.isDark = false,
    this.locale = "en",
    this.theme = "blue", // القيمة الافتراضية هي الثيم الأزرق
  });

  ThemeAndLocalState copyWith({
    bool? isDark,
    String? locale,
    String? theme,
  }) {
    return ThemeAndLocalState(
      isDark: isDark ?? this.isDark,
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}