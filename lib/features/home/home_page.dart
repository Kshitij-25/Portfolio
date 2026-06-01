import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../sections/about_section.dart';
import '../sections/achievements_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import 'widgets/ambient_background.dart';
import 'widgets/command_palette.dart';
import 'widgets/floating_dock.dart';
import 'widgets/mobile_menu.dart';
import 'widgets/nav_bar.dart';

/// Section identifiers used for nav, dock and command-palette targets.
enum SectionId { hero, about, skills, projects, experience, achievements, contact }

extension on SectionId {
  String get label => switch (this) {
        SectionId.hero => 'Home',
        SectionId.about => 'About',
        SectionId.skills => 'Skills',
        SectionId.projects => 'Projects',
        SectionId.experience => 'Experience',
        SectionId.achievements => 'Achievements',
        SectionId.contact => 'Contact',
      };

  IconData get icon => switch (this) {
        SectionId.hero => Icons.home_rounded,
        SectionId.about => Icons.person_outline_rounded,
        SectionId.skills => Icons.auto_awesome_rounded,
        SectionId.projects => Icons.grid_view_rounded,
        SectionId.experience => Icons.work_outline_rounded,
        SectionId.achievements => Icons.emoji_events_outlined,
        SectionId.contact => Icons.mail_outline_rounded,
      };
}

/// The single-page portfolio. Owns the scroll controller, per-section keys,
/// active-section tracking and the global keyboard shortcut for ⌘K.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);

  // Keys for nav targets (hero..contact). Footer reuses these.
  final Map<SectionId, GlobalKey> _keys = {
    for (final s in SectionId.values) s: GlobalKey(),
  };

  // Sections shown in the top nav (a curated subset).
  static const _navSections = [
    SectionId.about,
    SectionId.skills,
    SectionId.projects,
    SectionId.experience,
    SectionId.contact,
  ];

  bool _scrolled = false;
  int _activeNav = -1;
  int _activeDock = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scroll.offset > 12;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    _updateActive();
  }

  void _updateActive() {
    // Determine which section's top is nearest just below the nav.
    const anchor = 140.0;
    SectionId? current;
    for (final s in SectionId.values) {
      final ctx = _keys[s]!.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= anchor + 10) current = s;
    }
    current ??= SectionId.hero;

    final navIdx = _navSections.indexOf(current);
    final dockIdx = SectionId.values.indexOf(current);
    if (navIdx != _activeNav || dockIdx != _activeDock) {
      setState(() {
        _activeNav = navIdx;
        _activeDock = dockIdx;
      });
    }
  }

  Future<void> _scrollTo(SectionId id) async {
    final ctx = _keys[id]!.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final target = _scroll.offset +
        box.localToGlobal(Offset.zero).dy -
        (id == SectionId.hero ? 0 : 96);
    _scroll.animateTo(
      target.clamp(0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 720),
      curve: AppSpace.ease,
    );
  }

  void _scrollByLabel(String label) {
    final match = SectionId.values.firstWhere(
      (s) => s.label.toLowerCase() == label.toLowerCase(),
      orElse: () => SectionId.hero,
    );
    _scrollTo(match);
  }

  void _openPalette() {
    final app = AppScope.of(context);
    showCommandPalette(context, [
      for (final s in SectionId.values)
        CommandAction(
          icon: s.icon,
          label: 'Go to ${s.label}',
          hint: 'Section',
          run: () => _scrollTo(s),
        ),
      CommandAction(
        icon: app.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        label: 'Toggle theme',
        hint: 'Appearance',
        run: app.toggleTheme,
      ),
      CommandAction(
        icon: Icons.file_download_outlined,
        label: 'Download résumé',
        hint: 'Action',
        run: _downloadResume,
      ),
    ]);
  }

  void _openMobileMenu() {
    showMobileMenu(
      context,
      sections: SectionId.values
          .map((s) => MobileMenuItem(s.label, s.icon, () => _scrollTo(s)))
          .toList(),
    );
  }

  void _downloadResume() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.palette.surface2,
          content: Text(
            'Résumé download would start here — wire to your PDF asset.',
            style: GoogleFonts.plusJakartaSans(color: context.palette.textPrimary),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK):
              const _OpenPaletteIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
              const _OpenPaletteIntent(),
        },
        child: Actions(
          actions: {
            _OpenPaletteIntent: CallbackAction<_OpenPaletteIntent>(
              onInvoke: (_) {
                _openPalette();
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: MouseRegion(
              onHover: (e) => _pointer.value = e.position,
              onExit: (_) => _pointer.value = null,
              child: Stack(
                children: [
                  // ambient animated background
                  Positioned.fill(
                    child: AmbientBackground(pointer: _pointer),
                  ),
                  // scrolling content
                  Positioned.fill(
                    child: SingleChildScrollView(
                      controller: _scroll,
                      child: Column(
                        children: [
                          KeyedSubtree(
                            key: _keys[SectionId.hero],
                            child: HeroSection(
                              onViewProjects: () => _scrollTo(SectionId.projects),
                              onContact: () => _scrollTo(SectionId.contact),
                              onResume: _downloadResume,
                            ),
                          ),
                          KeyedSubtree(
                              key: _keys[SectionId.about],
                              child: const AboutSection()),
                          KeyedSubtree(
                              key: _keys[SectionId.skills],
                              child: const SkillsSection()),
                          KeyedSubtree(
                              key: _keys[SectionId.projects],
                              child: const ProjectsSection()),
                          KeyedSubtree(
                              key: _keys[SectionId.experience],
                              child: const ExperienceSection()),
                          KeyedSubtree(
                              key: _keys[SectionId.achievements],
                              child: const AchievementsSection()),
                          KeyedSubtree(
                              key: _keys[SectionId.contact],
                              child: const ContactSection()),
                          FooterSection(onNavigate: _scrollByLabel),
                          const SizedBox(height: 96), // room for the dock
                        ],
                      ),
                    ),
                  ),
                  // sticky nav
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: NavBar(
                      scrolled: _scrolled,
                      activeIndex: _activeNav,
                      onOpenPalette: _openPalette,
                      onOpenMenu: _openMobileMenu,
                      onContact: () => _scrollTo(SectionId.contact),
                      targets: [
                        for (final s in _navSections)
                          NavTarget(s.label, () => _scrollTo(s)),
                      ],
                    ),
                  ),
                  // floating dock (desktop/tablet only)
                  if (isDesktop)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: FloatingDock(
                        activeIndex: _activeDock,
                        items: [
                          for (final s in SectionId.values)
                            DockItem(s.icon, s.label, () => _scrollTo(s)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenPaletteIntent extends Intent {
  const _OpenPaletteIntent();
}
