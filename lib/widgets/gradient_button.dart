import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final List<Color>? gradientColors;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.gradientColors,
    this.borderRadius = 15,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradientColors ??
                [
                  AppTheme.primaryGradientStart,
                  AppTheme.primaryGradientEnd,
                ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color:
                  (widget.gradientColors?.last ?? AppTheme.primaryGradientEnd)
                      .withOpacity(_isPressed ? 0.3 : 0.5),
              blurRadius: _isPressed ? 10 : 20,
              offset: Offset(0, _isPressed ? 5 : 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: widget.isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
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

class OutlineGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;

  const OutlineGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryGradientStart,
            AppTheme.primaryGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E21),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppTheme.primaryGradientStart,
                          AppTheme.primaryGradientEnd,
                        ],
                      ).createShader(bounds),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppTheme.primaryGradientStart,
                        AppTheme.primaryGradientEnd,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
