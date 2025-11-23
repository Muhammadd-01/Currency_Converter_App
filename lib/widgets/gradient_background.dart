import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ??
              [
                const Color(0xFF0F2027),
                const Color(0xFF203A43),
                const Color(0xFF2C5364),
              ],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFF0F2027),
                  const Color(0xFF4A00E0),
                  _animation.value,
                )!,
                Color.lerp(
                  const Color(0xFF203A43),
                  const Color(0xFF8E2DE2),
                  _animation.value,
                )!,
                Color.lerp(
                  const Color(0xFF2C5364),
                  const Color(0xFF0F2027),
                  _animation.value,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
