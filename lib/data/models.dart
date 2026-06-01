import 'package:flutter/material.dart';

/// Immutable domain models for the portfolio content.

class SocialLink {
  const SocialLink({required this.label, required this.url, required this.icon});
  final String label;
  final String url;
  final IconData icon;
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
}

class Skill {
  const Skill({required this.name, required this.level, required this.group});
  final String name;
  final int level;
  final String group;
}

class Metric {
  const Metric(this.k, this.v);
  final String k;
  final String v;
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
}
