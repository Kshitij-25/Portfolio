import 'package:flutter/material.dart';

/// Curated accent gradients the theme switcher can cycle through.
/// The first/last colours seed every gradient in the UI.
class AccentOption {
  const AccentOption(this.label, this.colors);
  final String label;
  final List<Color> colors;
}

const kDefaultAccent =
    AccentOption('Blue → Violet', [Color(0xFF5B8CFF), Color(0xFFB98CFF)]);

const kAccentOptions = <AccentOption>[
  kDefaultAccent,
  AccentOption('Electric Blue', [Color(0xFF4F7DFF), Color(0xFF6FB1FF)]),
  AccentOption('Mint', [Color(0xFF3DDBB8), Color(0xFF5B8CFF)]),
  AccentOption('Violet', [Color(0xFF9A6BFF), Color(0xFFC78CFF)]),
  AccentOption('Coral', [Color(0xFFFF8A5B), Color(0xFFFF5B8C)]),
];

/// App-wide reactive state: theme mode + accent gradient.
/// Exposed through [AppScope] so any widget can read/listen with
/// `AppScope.of(context)`.
class AppState extends ChangeNotifier {
  AppState({
    ThemeMode themeMode = ThemeMode.dark,
    AccentOption accent = kDefaultAccent,
  })  : _themeMode = themeMode,
        _accent = accent;

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  AccentOption _accent;
  AccentOption get accent => _accent;
  Color get accentA => _accent.colors.first;
  Color get accentB => _accent.colors.last;

  void setAccent(AccentOption value) {
    _accent = value;
    notifyListeners();
  }

  /// The signature 135° accent gradient used across buttons, text and glows.
  LinearGradient gradient({double opacity = 1}) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentA.withValues(alpha: opacity),
          accentB.withValues(alpha: opacity),
        ],
      );
}

/// Inherited access point for [AppState]. Rebuilds dependents on change.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
