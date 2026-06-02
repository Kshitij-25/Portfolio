import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/state/app_scope.dart';
import 'core/theme/app_theme.dart';
import 'data/portfolio_data.dart';
import 'features/home/home_page.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final AppState _state = AppState();

  // Load the runtime content once. Kept as a field so hot reload / rebuilds
  // don't refetch. See [_ContentGate] for the loading & error UI.
  late Future<void> _contentLoad = PortfolioData.load();

  void _retryLoad() => setState(() => _contentLoad = PortfolioData.load());

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
            home: _ContentGate(
              future: _contentLoad,
              onRetry: _retryLoad,
            ),
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

/// Holds the UI back until [PortfolioData.load] resolves, then shows the
/// portfolio. Surfaces a retry on the (rare) chance content fails to parse.
class _ContentGate extends StatelessWidget {
  const _ContentGate({required this.future, required this.onRetry});

  final Future<void> future;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) return _LoadError(onRetry: onRetry);
            return const HomePage();
          default:
            return const _LoadingScreen();
        }
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: CircularProgressIndicator(
          color: AppScope.of(context).accentA,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Couldn't load content."),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
