import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/state/app_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: AnimatedBuilder(
        animation: _state,
        builder: (context, _) {
          final seed = _state.accentA;
          return MaterialApp(
            title: 'Kshitij Passi — Software Engineer',
            debugShowCheckedModeBanner: false,
            themeMode: _state.themeMode,
            theme: AppTheme.light(seed),
            darkTheme: AppTheme.dark(seed),
            scrollBehavior: const _SmoothScrollBehavior(),
            // Respect OS/browser font-scaling for accessibility, but clamp it so
            // extreme settings can't break the tightly-tuned layouts.
            builder: (context, child) => MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.2,
              child: child!,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

/// Enables mouse-drag scrolling on web/desktop and a tuned scroll physics feel.
class _SmoothScrollBehavior extends MaterialScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
