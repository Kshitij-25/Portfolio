import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';

class CommandAction {
  const CommandAction({
    required this.icon,
    required this.label,
    required this.hint,
    required this.run,
  });
  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback run;
}

/// Opens the ⌘K command palette as a top-anchored modal with live filtering
/// and arrow-key navigation.
Future<void> showCommandPalette(
  BuildContext context,
  List<CommandAction> actions,
) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Command palette',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => _CommandPalette(actions: actions),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppSpace.easeOut);
      return Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * -16),
          child: Transform.scale(
            scale: 0.98 + curved.value * 0.02,
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      );
    },
  );
}

class _CommandPalette extends StatefulWidget {
  const _CommandPalette({required this.actions});
  final List<CommandAction> actions;

  @override
  State<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<_CommandPalette> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  String _query = '';
  int _selected = 0;

  List<CommandAction> get _filtered {
    if (_query.trim().isEmpty) return widget.actions;
    final q = _query.toLowerCase();
    return widget.actions
        .where((a) =>
            a.label.toLowerCase().contains(q) ||
            a.hint.toLowerCase().contains(q))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _run(CommandAction action) {
    Navigator.of(context).pop();
    action.run();
  }

  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final results = _filtered;
    if (results.isEmpty) return;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _selected = (_selected + 1) % results.length);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(
          () => _selected = (_selected - 1 + results.length) % results.length);
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      _run(results[_selected.clamp(0, results.length - 1)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final results = _filtered;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: AppSpace.brLg,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppSpace.brLg,
                    color: palette.surface.withValues(alpha: 0.82),
                    border: Border.all(color: palette.borderStrong),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 60,
                        offset: const Offset(0, 30),
                      ),
                    ],
                  ),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: _onKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // search field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                          child: Row(
                            children: [
                              Icon(Icons.search_rounded,
                                  size: 18, color: palette.textTertiary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focus,
                                  onChanged: (v) => setState(() {
                                    _query = v;
                                    _selected = 0;
                                  }),
                                  cursorColor: app.accentA,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    color: palette.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: 'Jump to a section…',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      color: palette.textTertiary,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: palette.border),
                                ),
                                child: Text(
                                  'ESC',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: palette.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: palette.border),
                        // results
                        Flexible(
                          child: results.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Text(
                                    'No matches',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: palette.textTertiary,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: results.length,
                                  itemBuilder: (context, i) {
                                    final a = results[i];
                                    final active = i == _selected;
                                    return _Row(
                                      action: a,
                                      active: active,
                                      onHover: () =>
                                          setState(() => _selected = i),
                                      onTap: () => _run(a),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.action,
    required this.active,
    required this.onHover,
    required this.onTap,
  });
  final CommandAction action;
  final bool active;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: AppSpace.brSm,
            color: active ? palette.surface2 : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: active
                      ? app.accentA.withValues(alpha: 0.16)
                      : palette.glass,
                ),
                child: Icon(
                  action.icon,
                  size: 16,
                  color: active ? app.accentA : palette.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  action.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Text(
                action.hint,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  color: palette.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
