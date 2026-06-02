# Kshitij Passi — Flutter Web Portfolio

A premium, fully responsive developer portfolio built with **Flutter Web** and
**Material 3**. Dark/light theming, a live accent-colour system, scroll-triggered
animations, a ⌘K command palette, a floating dock, a GitHub-style contribution
heatmap, project detail overlays and a validated contact form.

> This Dart codebase implements the approved HTML design 1:1 (tokens, layout,
> motion). It is a real Flutter project — run it locally with the steps below.

---

## Quick start

```bash
cd flutter_portfolio
flutter pub get
flutter run -d chrome                  # dev
# release bundle (WasmGC renderer — noticeably smoother):
flutter build web --wasm --release     # output in build/web (deploys automatically — see below)
# convenience wrapper for the same command:
./tool/build_web.sh
```

Requires Flutter **3.27+** (Dart 3.6+) for the `Color.withValues` API.

> **Build with `--wasm`.** The portfolio is animation-heavy and uses live
> backdrop blur; the WasmGC renderer is the smoothest option on the web and is
> the recommended way to ship this app.

### Deploy (automated)

Deployment is fully automated via GitHub Actions
([`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)):

```bash
git push origin main      # ← that's it
```

Every push to `main` builds the WasmGC web bundle and publishes it to the
`gh-pages` branch, which GitHub Pages serves at
`https://<user>.github.io/Portfolio/`. You can also trigger a re-deploy
manually from the repo's **Actions** tab (workflow_dispatch).

**One-time setup:** in **Settings → Pages**, set *Source* to *Deploy from a
branch* → `gh-pages` / `root`. The workflow uses the built-in `GITHUB_TOKEN`,
so no extra secrets are needed.

> Building for a different path/domain? Update `--base-href` in the workflow
> (it must match the Pages URL path and start/end with `/`).

---

## Architecture

Clean, feature-first structure with a reusable design system and a single
source of truth for content.

```
lib/
├── main.dart                     # entry → runApp(PortfolioApp)
├── app.dart                      # MaterialApp, theme/accent wiring, scroll behavior
│
├── core/                         # cross-cutting, reusable foundation
│   ├── state/
│   │   └── app_scope.dart        # AppState (theme + accent) via InheritedNotifier
│   ├── theme/
│   │   ├── app_colors.dart       # raw colour tokens (dark + light)
│   │   ├── app_palette.dart      # ThemeExtension<AppPalette> → context.palette
│   │   ├── app_typography.dart   # Space Grotesk / Plus Jakarta Sans / JetBrains Mono
│   │   ├── app_spacing.dart      # radii, section rhythm, motion curves/durations
│   │   └── app_theme.dart        # builds Material 3 ThemeData (dark/light)
│   ├── responsive/
│   │   └── responsive.dart       # breakpoints, Responsive.value(), ContentWrap
│   └── widgets/                  # the component kit
│       ├── gradient_button.dart  # primary / ghost pill button (hover + press)
│       ├── glass_card.dart       # frosted glass surface w/ hover lift
│       ├── gradient_text.dart    # accent-gradient text via ShaderMask
│       ├── chip_tag.dart         # monospace tech chip
│       ├── animated_counter.dart # count-up-on-scroll number
│       ├── skill_bar.dart        # fill-on-scroll proficiency bar
│       ├── reveal_on_scroll.dart # fade+slide reveal driven by scroll position
│       └── section_header.dart   # eyebrow + headline + subtitle
│
├── data/
│   ├── models.dart               # immutable domain models (+ fromJson parsing)
│   └── portfolio_data.dart       # runtime loader + typed accessors for the JSON
│
└── features/
    ├── home/
    │   ├── home_page.dart         # page assembly, scroll wiring, active-section,
    │   │                          #   ⌘K shortcut, resume action
    │   └── widgets/
    │       ├── nav_bar.dart       # sticky glass nav (collapses < 900px)
    │       ├── floating_dock.dart # macOS-style dock (desktop)
    │       ├── command_palette.dart # ⌘K modal w/ filter + arrow keys
    │       ├── mobile_menu.dart   # slide-in drawer
    │       └── ambient_background.dart # drifting orbs, grid, mouse-follow glow
    └── sections/
        ├── section_shell.dart     # consistent vertical rhythm + max width
        ├── hero_section.dart      # staggered entrance, CTAs, social links
        ├── hero_mockup.dart       # floating Flutter-app phone mockup
        ├── about_section.dart     # bio, passion, journey timeline, stat cards
        ├── skills_section.dart    # skill bars + grouped tech-stack cards
        ├── projects_section.dart  # filterable grid of project cards
        ├── project_preview.dart   # gradient app-shot stand-in (no image assets)
        ├── project_detail.dart    # full project overlay (modal)
        ├── experience_section.dart# vertical role timeline
        ├── testimonials_section.dart
        ├── achievements_section.dart # metrics + contribution heatmap + certs
        ├── contact_section.dart   # validated form + animated send button
        └── footer_section.dart    # brand, quick links, socials, copyright
```

### Design system

- **Colour** — `AppColors` holds raw tokens; `AppPalette` (a `ThemeExtension`)
  exposes semantic colours (`context.palette.surface`, `…textSecondary`) that
  **animate** when the theme toggles. The accent is a runtime gradient
  (`AppState.gradient()`) used by buttons, text, bars, glows and the dock.
- **Type** — Space Grotesk (display), Plus Jakarta Sans (body), JetBrains Mono
  (labels/code), via `google_fonts`.
- **Spacing/motion** — `AppSpace` centralises radii, section padding, and the
  signature easing curves so timing is consistent everywhere.

### State management

Lightweight and dependency-free: `AppState extends ChangeNotifier` is provided
through `AppScope` (an `InheritedNotifier`). Any widget reads it with
`AppScope.of(context)` and rebuilds on theme/accent change. Swappable for
Riverpod/Bloc later without touching widgets.

### Animations

All native Flutter (no animation packages), so there are no fragile APIs:

- **Entrance** — `AnimationController` + `Interval` staggering (hero).
- **Reveal on scroll** — widgets listen to the `ScrollPosition` and fire a
  one-shot fade+slide when they enter the viewport (`RevealOnScroll`,
  `AnimatedCounter`, `SkillBar`, heatmap). Resting state is always visible, so
  content can never get stuck hidden.
- **Ambient** — a looping controller drifts the background orbs; a
  `MouseRegion` feeds pointer position into a radial glow.
- **Micro-interactions** — hover lifts, press scales, animated borders via
  `AnimatedContainer`.

### Responsiveness

`Responsive.value(context, mobile:…, tablet:…, desktop:…)` drives column counts,
font sizes and gutters. Breakpoints: mobile ≤ 680, tablet ≤ 1024, desktop above.
The nav collapses to a slide-in drawer below 900px; the floating dock shows on
desktop only.

---

## Content (dynamic JSON)

All content lives in a single JSON document — **not** baked into the compiled
build — so it can be edited on the deployed site without rebuilding.

- **Source of truth:** [`web/data/portfolio.json`](web/data/portfolio.json)
  (identity, stats, about, skills, projects, experience, achievements, certs).
- **At runtime** the app fetches `data/portfolio.json` (relative to the site
  root) with a cache-busting query, so the freshest copy always wins. If the
  fetch fails (mobile / offline), it falls back to the bundled
  `assets/portfolio.json`. `./tool/build_web.sh` syncs that bundled copy from
  the live file at build time, so you only ever edit `web/data/portfolio.json`.
- **Colours** are `#RRGGBB` hex strings; **icons** are friendly names mapped in
  `kIconByName` (`lib/data/models.dart`) — add a new key there to use a new icon.

### Update content WITHOUT redeploying

The deployed site serves `data/portfolio.json` as a plain static file:

1. Edit `data/portfolio.json` on the **`gh-pages`** branch (e.g. in the GitHub
   web editor) and commit.
2. Reload the site — the new content loads on the next visit. No
   `flutter build`, no redeploy of the app bundle.

> Keep `web/data/portfolio.json` in source in sync when you do this, so the next
> full build ships the same content.

## Customise

- **Content** — see [Content (dynamic JSON)](#content-dynamic-json) above;
  edit `web/data/portfolio.json`.
- **Accent colours** — edit `kAccentOptions` in `lib/core/state/app_scope.dart`.
  The current default is the blue→violet gradient.
- **Default theme** — change `AppState(themeMode: …)` in `app.dart`.
- **Résumé / live links** — wire `_downloadResume` in `home_page.dart` and the
  demo/code URLs in `project_detail.dart` to your real assets.
- **Fonts** — swap families in `lib/core/theme/app_typography.dart`.

## Suggested next steps

- Replace `ProjectPreview` gradient stand-ins with real screenshots
  (`assets/` + `Image.asset`).
- Add `go_router` if you want shareable per-project routes.
- Drop in a Lottie/Rive splash if you want richer loading motion.
```
