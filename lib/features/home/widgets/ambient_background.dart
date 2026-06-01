import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_palette.dart';

/// Fixed full-bleed ambient layer: a subtle grid, three slowly drifting accent
/// orbs, and a pointer-following glow. Sits behind all content (matches
/// `.bg-field`, `.bg-orb`, `.mouse-glow`).
///
/// Performance notes: each orb is an expensive gaussian blur, so it is
/// rasterised once behind a [RepaintBoundary] and merely *translated* every
/// frame (no per-frame re-blur). The pointer glow lives in its own
/// [RepaintBoundary] driven only by the pointer, so mouse movement never
/// repaints the orbs or grid.
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, required this.pointer});

  /// Latest pointer position in global coordinates, or null when off-screen.
  final ValueListenable<Offset?> pointer;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final size = MediaQuery.sizeOf(context);
    final blend = Color.lerp(app.accentA, app.accentB, 0.5)!;

    // Orbs are built once per (theme/accent/size) change — never per frame —
    // so their cached blur raster survives across the drift animation.
    return IgnorePointer(
      child: RepaintBoundary(
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: palette.bg)),
            // drifting orbs — only a Transform offset changes each frame
            _drift(
              _orb(size.width * 0.5, app.accentA, palette.haloOpacity),
              left: -size.width * 0.08,
              top: -size.width * 0.14,
              ax: 60,
              ay: 50,
              px: 0,
              py: 0.3,
            ),
            _drift(
              _orb(size.width * 0.42, app.accentB, palette.haloOpacity),
              left: size.width * 0.62,
              top: size.height * 0.06,
              ax: -50,
              ay: 60,
              px: 0.5,
              py: 0.7,
            ),
            _drift(
              _orb(size.width * 0.36, blend, palette.haloOpacity * 0.6),
              left: size.width * 0.32,
              top: size.height * 0.7,
              ax: 40,
              ay: -50,
              px: 0.2,
              py: 0.9,
            ),
            // faint grid mask near the top (static — cached)
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _GridPainter(color: palette.gridLine),
                ),
              ),
            ),
            // pointer glow — isolated so mouse moves don't repaint the orbs
            Positioned.fill(
              child: _PointerGlow(pointer: widget.pointer, color: app.accentA),
            ),
          ],
        ),
      ),
    );
  }

  /// Wraps a (cached) [orb] in a fixed [Positioned] and animates only its
  /// translation, so the gaussian blur raster is reused rather than recomputed.
  Widget _drift(
    Widget orb, {
    required double left,
    required double top,
    required double ax,
    required double ay,
    required double px,
    required double py,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return Transform.translate(
            offset: Offset(_wave(t, px) * ax, _wave(t, py) * ay),
            child: child,
          );
        },
        child: orb,
      ),
    );
  }

  double _wave(double t, double phase) {
    final v = (t + phase) % 1.0;
    // smooth 0->1->0 triangle eased
    final tri = v < 0.5 ? v * 2 : (1 - v) * 2;
    return Curves.easeInOut.transform(tri);
  }

  Widget _orb(double diameter, Color color, double opacity) {
    final o = opacity.clamp(0.0, 1.0);
    // Opacity is baked into the gradient (instead of an Opacity widget) to avoid
    // a per-orb saveLayer; the RepaintBoundary caches the blurred result.
    return RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: o),
                color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.7],
            ),
          ),
        ),
      ),
    );
  }
}

/// A soft radial glow that follows the pointer. Rebuilds only when the pointer
/// moves, and is isolated behind a [RepaintBoundary].
class _PointerGlow extends StatelessWidget {
  const _PointerGlow({required this.pointer, required this.color});

  final ValueListenable<Offset?> pointer;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder<Offset?>(
        valueListenable: pointer,
        builder: (context, value, _) {
          if (value == null) return const SizedBox.expand();
          return Stack(
            children: [
              Positioned(
                left: value.dx - 260,
                top: value.dy - 260,
                child: Container(
                  width: 520,
                  height: 520,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withValues(alpha: 0.16),
                        color.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 64.0;
    final maxY = size.height * 0.55;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, maxY), paint);
    }
    for (double y = 0; y < maxY; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}
