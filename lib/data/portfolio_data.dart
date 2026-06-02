import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'models.dart';

/// Relative path (from the deployed site root) to the editable content file.
/// On the web this is served as a plain static file — edit it on the deployed
/// branch and the content updates with no rebuild.
const _kContentUrl = 'data/portfolio.json';

/// Bundled copy shipped inside the app. Used as an offline / mobile fallback
/// and as last-known-good content if the live file can't be fetched.
const _kBundledAsset = 'assets/portfolio.json';

/// All portfolio content, parsed from a single JSON document.
class PortfolioContent {
  const PortfolioContent({
    required this.identity,
    required this.stats,
    required this.about,
    required this.skills,
    required this.projects,
    required this.experience,
    required this.achievements,
    required this.certifications,
  });

  final Identity identity;
  final List<StatItem> stats;
  final AboutInfo about;
  final List<Skill> skills;
  final List<Project> projects;
  final List<ExperienceItem> experience;
  final List<Achievement> achievements;
  final List<String> certifications;

  factory PortfolioContent.fromJson(Map<String, dynamic> j) => PortfolioContent(
        identity: Identity.fromJson(j['identity'] as Map<String, dynamic>),
        stats: (j['stats'] as List<dynamic>)
            .map((e) => StatItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        about: AboutInfo.fromJson(j['about'] as Map<String, dynamic>),
        skills: (j['skills'] as List<dynamic>)
            .map((e) => Skill.fromJson(e as Map<String, dynamic>))
            .toList(),
        projects: (j['projects'] as List<dynamic>)
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList(),
        experience: (j['experience'] as List<dynamic>)
            .map((e) => ExperienceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        achievements: (j['achievements'] as List<dynamic>)
            .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
            .toList(),
        certifications:
            (j['certifications'] as List<dynamic>).cast<String>(),
      );
}

/// Single access point for portfolio content.
///
/// Call [load] once at startup (before building the UI), then read the static
/// getters anywhere — they delegate to the loaded [PortfolioContent].
class PortfolioData {
  PortfolioData._();

  static PortfolioContent? _content;
  static bool get isLoaded => _content != null;

  /// Fetches the content. Tries the live network file first (so edits to the
  /// deployed JSON appear without a rebuild), then falls back to the bundled
  /// asset for mobile / offline / fetch failures.
  static Future<void> load() async {
    if (_content != null) return;

    Map<String, dynamic>? json = await _fetchLive();
    json ??= await _loadBundled();
    _content = PortfolioContent.fromJson(json);
  }

  /// Fetches the live file over HTTP with a cache-busting query so a freshly
  /// edited JSON isn't masked by a stale browser / CDN copy. Returns null on
  /// any failure (e.g. on mobile, where the relative URL doesn't resolve).
  static Future<Map<String, dynamic>?> _fetchLive() async {
    try {
      final uri = Uri.base.resolve(_kContentUrl).replace(
        queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      if (!uri.scheme.startsWith('http')) return null;
      final res =
          await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('PortfolioData: live fetch failed, using bundled copy ($e)');
      return null;
    }
  }

  static Future<Map<String, dynamic>> _loadBundled() async {
    final raw = await rootBundle.loadString(_kBundledAsset);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static PortfolioContent get _c {
    final c = _content;
    assert(c != null, 'PortfolioData.load() must complete before reading data.');
    return c!;
  }

  static Identity get identity => _c.identity;
  static List<StatItem> get stats => _c.stats;
  static AboutInfo get about => _c.about;
  static List<Skill> get skills => _c.skills;
  static List<Project> get projects => _c.projects;
  static List<ExperienceItem> get experience => _c.experience;
  static List<Achievement> get achievements => _c.achievements;
  static List<String> get certifications => _c.certifications;
}
