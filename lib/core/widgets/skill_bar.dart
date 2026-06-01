import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_scope.dart';
import '../theme/app_palette.dart';

/// Labelled skill bar that fills to [level]% the first time it scrolls into
/// view, with the value counting up alongside.
class SkillBar extends StatefulWidget {
  const SkillBar({super.key, required this.name, required this.level});

  final String name;
  final int level;

  @override
  State<SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (dy < screenH - 40) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        final pct = (widget.level * t).round();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  '$pct%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    color: palette.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                children: [
                  Container(height: 6, color: palette.surface2),
                  FractionallySizedBox(
                    widthFactor: (widget.level / 100) * t,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: app.gradient(),
                        boxShadow: [
                          BoxShadow(
                            color: app.accentA.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
