import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// Contact: split layout — left is a CTA + direct email + socials, right is a
/// validated message form with an animated send button (idle → sending → sent).
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final id = PortfolioData.identity;
    final isDesktop = Responsive.isDesktop(context);

    final left = _ContactCopy(identity: id);
    final right = const _ContactForm();

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Contact',
            title: 'Let\'s build something ',
            titleAccent: 'great.',
            subtitle:
                'Have a project, a role, or just want to say hi? My inbox is '
                'always open.',
          ),
          const SizedBox(height: 48),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: left),
                    const SizedBox(width: 40),
                    Expanded(flex: 5, child: right),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    left,
                    const SizedBox(height: 32),
                    right,
                  ],
                ),
        ],
      ),
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy({required this.identity});
  final Identity identity;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            hoverLift: false,
            onTap: () async {
              final uri = Uri(scheme: 'mailto', path: identity.email);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: AppSpace.brSm,
                    gradient: app.gradient(),
                  ),
                  child: const Icon(Icons.mail_outline_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email me',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: palette.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Scale the address down rather than overflow on narrow cards.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          identity.email,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Follow along',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.5,
              color: palette.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in identity.socials) _SocialButton(link: s),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({required this.link});
  final SocialLink link;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.link.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: AppSpace.fast,
          transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            color: _hover ? palette.surface2 : palette.glass,
            border: Border.all(color: _hover ? app.accentA : palette.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.link.icon,
                  size: 16,
                  color: _hover ? palette.textPrimary : palette.textSecondary),
              const SizedBox(width: 9),
              Text(
                widget.link.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: _hover ? palette.textPrimary : palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SendState { idle, sending, sent }

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  _SendState _state = _SendState.idle;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_state != _SendState.idle) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _state = _SendState.sending);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _state = _SendState.sent);
    await Future.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;
    setState(() {
      _state = _SendState.idle;
      _name.clear();
      _email.clear();
      _message.clear();
      _formKey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: GlassCard(
        hoverLift: false,
        padding: const EdgeInsets.all(26),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      controller: _name,
                      label: 'Name',
                      hint: 'Ada Lovelace',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Field(
                      controller: _email,
                      label: 'Email',
                      hint: 'you@company.com',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+')
                            .hasMatch(v.trim());
                        return ok ? null : 'Enter a valid email';
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Field(
                controller: _message,
                label: 'Message',
                hint: 'Tell me about your project…',
                maxLines: 5,
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'A little more detail, please'
                    : null,
              ),
              const SizedBox(height: 22),
              _SendButton(state: _state, onTap: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11.5,
            letterSpacing: 0.5,
            color: palette.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          cursorColor: app.accentA,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: palette.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: palette.textTertiary,
            ),
            filled: true,
            fillColor: palette.surface2,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpace.brSm,
              borderSide: BorderSide(color: palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpace.brSm,
              borderSide: BorderSide(color: app.accentA, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpace.brSm,
              borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpace.brSm,
              borderSide:
                  const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
            ),
            errorStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFFFF8A8A),
            ),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({required this.state, required this.onTap});
  final _SendState state;
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final sent = widget.state == _SendState.sent;
    final sending = widget.state == _SendState.sending;

    Widget child;
    if (sending) {
      child = const SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    } else if (sent) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 18, color: Colors.white),
          const SizedBox(width: 9),
          Text('Message sent!',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Send message',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  color: Colors.white)),
          const SizedBox(width: 9),
          const Icon(Icons.send_rounded, size: 16, color: Colors.white),
        ],
      );
    }

    final green = [const Color(0xFF2BBF8E), const Color(0xFF3DDBB8)];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppSpace.base,
          curve: AppSpace.ease,
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          transform:
              Matrix4.translationValues(0, _hover && !sending ? -2 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            gradient: LinearGradient(
              colors: sent ? green : app.gradient().colors,
            ),
            boxShadow: [
              BoxShadow(
                color: (sent ? green.first : app.accentA)
                    .withValues(alpha: _hover ? 0.5 : 0.32),
                blurRadius: _hover ? 40 : 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(widget.state),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
