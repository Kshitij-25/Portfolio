import 'package:flutter/material.dart';

import 'models.dart';

/// Single source of truth for all portfolio content.
/// Sourced from Kshitij Passi's resume — edit freely.
class PortfolioData {
  PortfolioData._();

  static const identity = Identity(
    name: 'Kshitij Passi',
    first: 'Kshitij',
    role: 'Software Engineer',
    handle: '@kshitijpassi',
    location: 'Ghaziabad, India',
    available: true,
    tagline: 'Building beautiful cross-platform experiences with Flutter.',
    intro:
        'I build cross-platform apps with Flutter across Web, iOS and Android — '
        'from banking-grade mobile clients to operations dashboards — with a '
        'focus on clean architecture, security and performance.',
    email: 'in.kshitijwork@gmail.com',
    socials: [
      SocialLink(
          label: 'GitHub',
          url: 'https://github.com/kshitij-25',
          icon: Icons.code_rounded),
      SocialLink(
          label: 'LinkedIn',
          url: 'https://linkedin.com/in/kshitij-passi',
          icon: Icons.business_center_rounded),
      SocialLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/dev?id=8836767775677848927',
          icon: Icons.android_rounded),
      SocialLink(
          label: 'Email',
          url: 'mailto:in.kshitijwork@gmail.com',
          icon: Icons.mail_outline_rounded),
    ],
  );

  static const stats = <StatItem>[
    StatItem(value: 4, suffix: '+', label: 'Years building'),
    StatItem(value: 10, suffix: '+', label: 'Apps shipped'),
    StatItem(value: 4, suffix: '', label: 'Companies'),
    StatItem(value: 99.9, suffix: '%', label: 'Peak uptime', decimals: 1),
  ];

  static const about = AboutInfo(
    bio: [
      "I'm a Software Engineer specializing in Flutter, building cross-platform "
          'apps for Web, iOS and Android. I care about clean architecture, '
          'security, and the polish that makes an app feel effortless.',
      "I've shipped products across banking, telephony, social and healthcare — "
          'owning everything from layered architecture and state management to '
          'API contracts and the last 5% of UI polish.',
    ],
    passion:
        'I believe great software is felt, not just used. Strong architecture, '
        'a hardened security posture and tight performance are what let a '
        'product earn trust at scale.',
    journey: [
      JourneyItem(
          year: '2025',
          title: 'Software Engineer',
          org: 'NeoSOFT',
          note:
              'Banking-grade Flutter apps for Bank of India (Starlight) & RSGT.'),
      JourneyItem(
          year: '2024',
          title: 'Software Developer',
          org: 'FBF Entertainment',
          note: "Built BRIEFSEA's real-time messaging for 500+ live sessions."),
      JourneyItem(
          year: '2023',
          title: 'Associate Software Developer',
          org: 'Suma Soft',
          note: 'Conferencing & dialer apps held to 99.5% uptime.'),
      JourneyItem(
          year: '2022',
          title: 'Software Developer',
          org: 'Avis e Solutions',
          note: 'Helpdesk, dialer & healthcare apps — started my dev career.'),
    ],
  );

  // First six entries render as proficiency bars; every entry is also grouped
  // into the tech-stack cards by [Skill.group].
  static const skills = <Skill>[
    Skill(name: 'Flutter', level: 97, group: 'Core'),
    Skill(name: 'Dart', level: 95, group: 'Core'),
    Skill(name: 'BLoC', level: 92, group: 'State'),
    Skill(name: 'Clean Architecture', level: 90, group: 'Core'),
    Skill(name: 'Riverpod', level: 86, group: 'State'),
    Skill(name: 'Firebase', level: 85, group: 'Tools'),
    // grouped-only (chips)
    Skill(name: 'MVVM', level: 85, group: 'Core'),
    Skill(name: 'MVC', level: 82, group: 'Core'),
    Skill(name: 'GetX', level: 82, group: 'State'),
    Skill(name: 'Provider', level: 84, group: 'State'),
    Skill(name: 'Spring Boot', level: 78, group: 'Backend'),
    Skill(name: 'FastAPI', level: 74, group: 'Backend'),
    Skill(name: 'Node.js', level: 76, group: 'Backend'),
    Skill(name: '.NET', level: 70, group: 'Backend'),
    Skill(name: 'PostgreSQL', level: 80, group: 'Data'),
    Skill(name: 'Hive', level: 86, group: 'Data'),
    Skill(name: 'Sembast', level: 80, group: 'Data'),
    Skill(name: 'Sqflite', level: 84, group: 'Data'),
    Skill(name: 'Git', level: 90, group: 'Tools'),
    Skill(name: 'Android Studio', level: 88, group: 'Tools'),
    Skill(name: 'VS Code', level: 90, group: 'Tools'),
    Skill(name: 'Xcode', level: 75, group: 'Tools'),
    Skill(name: 'SIP', level: 78, group: 'Protocols'),
    Skill(name: 'MQTT', level: 80, group: 'Protocols'),
    Skill(name: 'Socket.IO', level: 84, group: 'Protocols'),
  ];

  static const projects = <Project>[
    Project(
      id: 'boi-starlight',
      title: 'BOI Starlight',
      category: 'Fintech',
      year: '2025',
      tagline: 'A banking-grade mobile client',
      description:
          'A secure banking app architected with BLoC + Clean Architecture for '
          'strict domain isolation. Hardened end-to-end with AES-256 local '
          'encryption, SSL certificate pinning and OAuth2/JWT token-lifecycle '
          'management.',
      tech: ['Flutter', 'BLoC', 'Clean Architecture', 'OAuth2/JWT'],
      accent: [Color(0xFF5B8CFF), Color(0xFF7C5CFF)],
      featured: true,
      metrics: [
        Metric('Encryption', 'AES-256'),
        Metric('Auth', 'OAuth2/JWT'),
        Metric('Architecture', 'Clean'),
      ],
    ),
    Project(
      id: 'rsgt',
      title: 'Red Sea Gateway',
      category: 'Cross-platform',
      year: '2025',
      tagline: 'One codebase, web + mobile',
      description:
          'A single-codebase Flutter Web & Mobile platform for a port terminal. '
          'Adaptive layouts bridge an operations dashboard and a field-agent '
          'app over a failure-typed Result data layer that let a team of 3 ship '
          'in parallel.',
      tech: ['Flutter Web', 'Flutter', 'Adaptive UI', 'Clean Architecture'],
      accent: [Color(0xFF3DDBB8), Color(0xFF5B8CFF)],
      featured: true,
      metrics: [
        Metric('Codebase', 'Web + Mobile'),
        Metric('Team', '3 devs'),
        Metric('Data layer', 'Result'),
      ],
    ),
    Project(
      id: 'briefsea',
      title: 'BRIEFSEA',
      category: 'Social',
      year: '2024',
      tagline: 'Real-time hiring & networking',
      description:
          'A social hiring platform with a real-time messaging subsystem on '
          'Socket.IO — event-based room isolation sustaining 500+ concurrent '
          'sessions, instrumented with Firebase Analytics and deep linking.',
      tech: ['Flutter', 'Socket.IO', 'Firebase', 'Node.js'],
      accent: [Color(0xFFB98CFF), Color(0xFFFF8A5B)],
      featured: true,
      metrics: [
        Metric('Concurrent', '500+'),
        Metric('UI consistency', '98%'),
        Metric('Realtime', 'Socket.IO'),
      ],
    ),
    Project(
      id: 'go4call',
      title: 'GO4CALL',
      category: 'Telephony',
      year: '2023',
      tagline: 'VoIP conferencing client',
      description:
          'A conferencing app with a protocol abstraction layer decoupling '
          'SIP/MQTT signaling from UI state, reaching 99.5% uptime. Re-architected '
          'the notification pipeline to cut missed-push failures by 95%.',
      tech: ['Flutter', 'SIP', 'MQTT', 'FCM'],
      accent: [Color(0xFF5BD1FF), Color(0xFF5B8CFF)],
      featured: false,
      metrics: [Metric('Uptime', '99.5%'), Metric('Missed pushes', '-95%')],
    ),
    Project(
      id: 'mindnest',
      title: 'MindNest',
      category: 'Full-stack',
      year: '2024',
      tagline: 'A mental-health platform, built solo',
      description:
          'A full-stack mental-health app architected end-to-end: a multi-tenant '
          'data model with role-isolated access, a versioned REST API and JWT '
          'auth with refresh-token rotation on Spring Boot + Neon PostgreSQL.',
      tech: ['Flutter', 'Spring Boot', 'PostgreSQL', 'JWT'],
      accent: [Color(0xFF7C5CFF), Color(0xFFB98CFF)],
      featured: false,
      metrics: [Metric('Stack', 'Full-stack'), Metric('Auth', 'JWT rotation')],
    ),
    Project(
      id: 'cocolife',
      title: 'COCOLIFE',
      category: 'Healthcare',
      year: '2022',
      tagline: 'Insurance platform at scale',
      description:
          'A mission-critical healthcare & insurance app held to a 99.95% uptime '
          'SLA through proactive performance profiling and coordinated .NET '
          'backend release synchronization during peak enrollment.',
      tech: ['Flutter', '.NET', 'FCM'],
      accent: [Color(0xFFFFB85B), Color(0xFFFF5B8C)],
      featured: false,
      metrics: [Metric('Uptime', '99.95%'), Metric('Domain', 'Insurance')],
    ),
  ];

  static const experience = <ExperienceItem>[
    ExperienceItem(
      period: 'Oct 2025 — Present',
      role: 'Software Engineer',
      company: 'NeoSOFT',
      type: 'Full-time',
      points: [
        "Defined a layered BLoC + Clean Architecture for Bank of India's "
            'Starlight banking app, with independently deployable, testable domains.',
        'Owned the mobile security posture: AES-256 storage, SSL pinning and '
            'OAuth2/JWT token-lifecycle management.',
        'Built RSGT as a single Flutter Web + Mobile codebase with adaptive '
            'layouts and a failure-typed data layer for a team of 3.',
      ],
    ),
    ExperienceItem(
      period: 'May 2024 — Jul 2025',
      role: 'Software Developer',
      company: 'FBF Entertainment',
      type: 'Remote',
      points: [
        "Built BRIEFSEA's real-time messaging on Socket.IO — room isolation "
            'sustaining 500+ concurrent sessions.',
        'Drove API contract definition with the Node.js team, reaching 98% UI '
            'consistency across device form factors.',
        'Instrumented Firebase Analytics & deep linking to ground feature '
            'prioritization in funnel metrics.',
      ],
    ),
    ExperienceItem(
      period: 'Aug 2023 — Apr 2024',
      role: 'Associate Software Developer',
      company: 'Suma Soft',
      type: 'Full-time',
      points: [
        'Designed a protocol abstraction layer for GO4CALL, decoupling SIP/MQTT '
            'signaling from UI state (99.5% uptime).',
        'Re-architected the notification pipeline to serialize delivery, cutting '
            'missed-push failures by 95%.',
        "Modelled FIELD AGENT's call lifecycle as a Riverpod state machine — "
            'zero critical crashes across three releases.',
      ],
    ),
    ExperienceItem(
      period: 'Jul 2022 — Aug 2023',
      role: 'Software Developer',
      company: 'Avis e Solutions',
      type: 'Full-time',
      points: [
        'Built a role-based access control model mapping agent/supervisor/admin '
            'tiers to .NET API authorization.',
        'Defined OTP + short-lived token auth for CONTAQUE Mobili with the '
            'Spring Boot team.',
        'Sustained 99.95% uptime for COCOLIFE, a mission-critical insurance '
            'platform, during peak enrollment.',
      ],
    ),
  ];

  static const achievements = <Achievement>[
    Achievement(
        value: 4,
        suffix: '+',
        label: 'Years of experience',
        icon: Icons.timeline_rounded),
    Achievement(
        value: 10,
        suffix: '+',
        label: 'Apps shipped',
        icon: Icons.rocket_launch_rounded),
    Achievement(
        value: 4,
        suffix: '',
        label: 'Companies',
        icon: Icons.apartment_rounded),
    Achievement(
        value: 99.95,
        suffix: '%',
        label: 'Peak uptime',
        icon: Icons.verified_rounded,
        decimals: 2),
    Achievement(
        value: 500,
        suffix: '+',
        label: 'Concurrent sessions',
        icon: Icons.bolt_rounded),
    Achievement(
        value: 98,
        suffix: '%',
        label: 'UI consistency',
        icon: Icons.devices_rounded),
  ];

  // Repurposed as a credentials strip (the resume lists no certifications).
  static const certifications = <String>[
    'B.Tech · Computer Science — JSS Academy',
    'Diploma · Electronics & Communication — Pusa Institute',
    'Clean Architecture & BLoC',
    'Mobile Security: AES-256 · OAuth2/JWT',
  ];
}
