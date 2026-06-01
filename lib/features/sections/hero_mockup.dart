import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';

/// The floating phone mockup shown beside the hero copy: a stylised Flutter app
/// UI with a gentle perpetual float and orbiting glass labels.
class HeroMockup extends StatefulWidget {
  const HeroMockup({super.key});

  @override
  State<HeroMockup> createState() => _HeroMockupState();
}

class _HeroMockupState extends State<HeroMockup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Design frame: the 360px phone plus the labels that overhang it.
          // Scaled down to fit narrower viewports so it never overflows.
          const designW = 404.0;
          const designH = 544.0;
          final maxW =
              constraints.maxWidth.isFinite ? constraints.maxWidth : designW;
          final scale = (maxW / designW).clamp(0.0, 1.0);
          return SizedBox(
            width: designW * scale,
            height: designH * scale,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: designW,
                height: designH,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final t = Curves.easeInOut.transform(_controller.value);
                      return SizedBox(
                        width: 360,
                        height: 520,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -8 + t * 16),
                              child: _phone(context),
                            ),
                            Positioned(
                              top: 26 + t * 10,
                              right: -6,
                              child: _floatLabel(context, '120 fps'),
                            ),
                            Positioned(
                              top: 232 - t * 8,
                              right: -22,
                              child: _floatLabel(context, 'Material 3'),
                            ),
                            Positioned(
                              bottom: 40 + t * 8,
                              left: -16,
                              child: _floatLabel(context, 'Flutter Web'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _phone(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      width: 268,
      height: 500,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        color: const Color(0xFF15171F),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: app.accentA.withValues(alpha: 0.28),
            blurRadius: 80,
            offset: const Offset(0, 30),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 50,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Container(
          color: const Color(0xFF0B0D14),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // status row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('9:41',
                      style: GoogleFonts.jetBrainsMono(
                          color: Colors.white70, fontSize: 12)),
                  Row(
                    children: [
                      Icon(Icons.wifi_rounded,
                          size: 13, color: Colors.white.withValues(alpha: 0.6)),
                      const SizedBox(width: 5),
                      Icon(Icons.battery_full_rounded,
                          size: 13, color: Colors.white.withValues(alpha: 0.6)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: AppSpace.br,
                  gradient: app.gradient(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Balance',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(r'$12,480.50',
                        style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 30,
                      child: CustomPaint(
                        size: const Size(double.infinity, 30),
                        painter: _SparkPainter(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text('Recent',
                  style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              for (var i = 0; i < 3; i++) _row(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(int i) {
    final colors = [
      const Color(0xFF5B8CFF),
      const Color(0xFF3DDBB8),
      const Color(0xFFB98CFF)
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colors[i].withValues(alpha: 0.22),
            ),
            child: Icon(Icons.bolt_rounded, size: 17, color: colors[i]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatLabel(BuildContext context, String text) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: AppSpace.pill,
        color: palette.surface.withValues(alpha: 0.9),
        border: Border.all(color: palette.borderStrong),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: palette.textPrimary,
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final pts = [0.0, 0.4, 0.2, 0.6, 0.45, 0.8, 0.65, 1.0];
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final x = size.width * (i / (pts.length - 1));
      final y = size.height * (1 - pts[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
