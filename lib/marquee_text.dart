import 'package:flutter/material.dart';

/// Pure-Flutter infinite scrolling marquee — no third-party packages.
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double velocity; // pixels per second

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.velocity = 70,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    final tp = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: double.infinity);
    _textWidth = tp.width;
    if (_textWidth > 0) {
      _ctrl.duration = Duration(milliseconds: (_textWidth / widget.velocity * 1000).round());
      _ctrl.repeat();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textWidth == 0) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 48),
        painter: _MarqueePainter(
          text: widget.text,
          style: widget.style,
          offset: -_ctrl.value * _textWidth,
          textWidth: _textWidth,
        ),
      ),
    );
  }
}

class _MarqueePainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final double offset;
  final double textWidth;

  const _MarqueePainter({
    required this.text,
    required this.style,
    required this.offset,
    required this.textWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: double.infinity);

    double x = offset % textWidth;
    if (x > 0) x -= textWidth;

    while (x < size.width) {
      tp.paint(canvas, Offset(x, (size.height - tp.height) / 2));
      x += textWidth;
    }
  }

  @override
  bool shouldRepaint(_MarqueePainter old) => old.offset != offset;
}