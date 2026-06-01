import 'package:flutter/widgets.dart';

/// Breakpoints + helpers for adaptive layouts.
enum DeviceClass { mobile, tablet, desktop }

class Responsive {
  Responsive._();

  static const double mobileMax = 680;
  static const double tabletMax = 1024;

  static DeviceClass of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w <= mobileMax) return DeviceClass.mobile;
    if (w <= tabletMax) return DeviceClass.tablet;
    return DeviceClass.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == DeviceClass.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == DeviceClass.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == DeviceClass.desktop;

  /// Pick a value per breakpoint, falling back upward.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (of(context)) {
      case DeviceClass.mobile:
        return mobile;
      case DeviceClass.tablet:
        return tablet ?? mobile;
      case DeviceClass.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Horizontal page gutter that grows with viewport.
  static double gutter(BuildContext context) =>
      value(context, mobile: 22.0, tablet: 40.0, desktop: 24.0);
}

/// Constrains content to the design's max width and adds responsive gutters.
class ContentWrap extends StatelessWidget {
  const ContentWrap({super.key, required this.child, this.maxWidth = 1180});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final gutter = Responsive.gutter(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
