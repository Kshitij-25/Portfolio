import 'package:flutter/material.dart';

import '../state/app_scope.dart';

/// Paints its [text] with the live accent gradient (matches `.grad-text`).
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final g = gradient ?? AppScope.of(context).gradient();
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => g.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}
