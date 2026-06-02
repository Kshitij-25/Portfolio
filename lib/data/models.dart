import 'package:flutter/material.dart';

/// Immutable domain models for the portfolio content.
///
/// Every model can be built from a plain JSON map ([fromJson]) so the content
/// can be loaded at runtime from `data/portfolio.json` instead of being baked
/// into the compiled build. See [PortfolioData.load].

/// Parses a `#RRGGBB` / `#AARRGGBB` (or prefix-less) hex string into a [Color].
Color colorFromHex(String hex) {
  var value = hex.trim().replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value'; // assume fully opaque
  return Color(int.parse(value, radix: 16));
}

/// JSON-friendly names mapped to the concrete icons used in the UI.
///
/// Using a fixed lookup (rather than raw code points) keeps Flutter's icon
/// tree-shaking working and lets the JSON reference icons by readable keys.
const Map<String, IconData> kIconByName = {
  'code': Icons.code_rounded,
  'business': Icons.business_center_rounded,
  'android': Icons.android_rounded,
  'mail': Icons.mail_outline_rounded,
  'timeline': Icons.timeline_rounded,
  'rocket': Icons.rocket_launch_rounded,
  'apartment': Icons.apartment_rounded,
  'verified': Icons.verified_rounded,
  'bolt': Icons.bolt_rounded,
  'devices': Icons.devices_rounded,
};

/// Resolves an icon [name] from [kIconByName], falling back to a neutral icon
/// so unknown keys never crash the UI.
IconData iconFromName(String? name) =>
    kIconByName[name] ?? Icons.bolt_rounded;

class SocialLink {
  const SocialLink({required this.label, required this.url, required this.icon});
  final String label;
  final String url;
  final IconData icon;

  factory SocialLink.fromJson(Map<String, dynamic> j) => SocialLink(
        label: j['label'] as String,
        url: j['url'] as String,
        icon: iconFromName(j['icon'] as String?),
      );
}

class Identity {
  const Identity({
    required this.name,
    required this.first,
    required this.role,
    required this.handle,
    required this.location,
    required this.available,
    required this.tagline,
    required this.intro,
    required this.email,
    required this.socials,
  });
  final String name;
  final String first;
  final String role;
  final String handle;
  final String location;
  final bool available;
  final String tagline;
  final String intro;
  final String email;
  final List<SocialLink> socials;

  factory Identity.fromJson(Map<String, dynamic> j) => Identity(
        name: j['name'] as String,
        first: j['first'] as String,
        role: j['role'] as String,
        handle: j['handle'] as String,
        location: j['location'] as String,
        available: j['available'] as bool? ?? true,
        tagline: j['tagline'] as String,
        intro: j['intro'] as String,
        email: j['email'] as String,
        socials: (j['socials'] as List<dynamic>)
            .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class StatItem {
  const StatItem({
    required this.value,
    required this.suffix,
    required this.label,
    this.decimals = 0,
  });
  final double value;
  final String suffix;
  final String label;
  final int decimals;

  factory StatItem.fromJson(Map<String, dynamic> j) => StatItem(
        value: (j['value'] as num).toDouble(),
        suffix: j['suffix'] as String? ?? '',
        label: j['label'] as String,
        decimals: (j['decimals'] as num?)?.toInt() ?? 0,
      );
}

class JourneyItem {
  const JourneyItem({
    required this.year,
    required this.title,
    required this.org,
    required this.note,
  });
  final String year;
  final String title;
  final String org;
  final String note;

  factory JourneyItem.fromJson(Map<String, dynamic> j) => JourneyItem(
        year: j['year'] as String,
        title: j['title'] as String,
        org: j['org'] as String,
        note: j['note'] as String,
      );
}

class AboutInfo {
  const AboutInfo({
    required this.bio,
    required this.passion,
    required this.journey,
  });
  final List<String> bio;
  final String passion;
  final List<JourneyItem> journey;

  factory AboutInfo.fromJson(Map<String, dynamic> j) => AboutInfo(
        bio: (j['bio'] as List<dynamic>).cast<String>(),
        passion: j['passion'] as String,
        journey: (j['journey'] as List<dynamic>)
            .map((e) => JourneyItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Skill {
  const Skill({required this.name, required this.level, required this.group});
  final String name;
  final int level;
  final String group;

  factory Skill.fromJson(Map<String, dynamic> j) => Skill(
        name: j['name'] as String,
        level: (j['level'] as num).toInt(),
        group: j['group'] as String,
      );
}

class Metric {
  const Metric(this.k, this.v);
  final String k;
  final String v;

  factory Metric.fromJson(Map<String, dynamic> j) =>
      Metric(j['k'] as String, j['v'] as String);
}

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.category,
    required this.year,
    required this.tagline,
    required this.description,
    required this.tech,
    required this.accent,
    required this.featured,
    required this.metrics,
    this.repo,
    this.demo,
  });
  final String id;
  final String title;
  final String category;
  final String year;
  final String tagline;
  final String description;
  final List<String> tech;
  final List<Color> accent;
  final bool featured;
  final List<Metric> metrics;

  /// Link to the source repository (e.g. GitHub). Null hides the "View Code" CTA.
  final String? repo;

  /// Link to a live/hosted demo. Null hides the "Live Demo" CTA.
  final String? demo;

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        id: j['id'] as String,
        title: j['title'] as String,
        category: j['category'] as String,
        year: j['year'] as String,
        tagline: j['tagline'] as String,
        description: j['description'] as String,
        tech: (j['tech'] as List<dynamic>).cast<String>(),
        accent: (j['accent'] as List<dynamic>)
            .map((e) => colorFromHex(e as String))
            .toList(),
        featured: j['featured'] as bool? ?? false,
        metrics: (j['metrics'] as List<dynamic>)
            .map((e) => Metric.fromJson(e as Map<String, dynamic>))
            .toList(),
        repo: j['repo'] as String?,
        demo: j['demo'] as String?,
      );
}

class ExperienceItem {
  const ExperienceItem({
    required this.period,
    required this.role,
    required this.company,
    required this.type,
    required this.points,
  });
  final String period;
  final String role;
  final String company;
  final String type;
  final List<String> points;

  factory ExperienceItem.fromJson(Map<String, dynamic> j) => ExperienceItem(
        period: j['period'] as String,
        role: j['role'] as String,
        company: j['company'] as String,
        type: j['type'] as String,
        points: (j['points'] as List<dynamic>).cast<String>(),
      );
}

class Achievement {
  const Achievement({
    required this.value,
    required this.suffix,
    required this.label,
    required this.icon,
    this.decimals = 0,
  });
  final double value;
  final String suffix;
  final String label;
  final IconData icon;
  final int decimals;

  factory Achievement.fromJson(Map<String, dynamic> j) => Achievement(
        value: (j['value'] as num).toDouble(),
        suffix: j['suffix'] as String? ?? '',
        label: j['label'] as String,
        icon: iconFromName(j['icon'] as String?),
        decimals: (j['decimals'] as num?)?.toInt() ?? 0,
      );
}
