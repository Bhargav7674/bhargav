import 'package:flutter/material.dart';

class WalletIconWidget extends StatelessWidget {
  const WalletIconWidget({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _WalletPainter());
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Drop shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.06, h * 0.14, w * 0.88, h * 0.82),
        Radius.circular(w * 0.22),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // Wallet body — gold gradient
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.04, h * 0.16, w * 0.92, h * 0.78),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD000), Color(0xFFE8A800), Color(0xFFC67000)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, h * 0.16, w, h * 0.78)),
    );

    // Subtle inner top highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.20, w * 0.84, h * 0.68),
        Radius.circular(w * 0.18),
      ),
      Paint()
        ..color = Colors.white.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Green flap — top of wallet
    final flapL = w * 0.20, flapR = w * 0.80;
    final flapT = h * 0.04, flapB = h * 0.28;
    final fr = w * 0.15;
    final flapPath = Path()
      ..moveTo(flapL + fr, flapT)
      ..lineTo(flapR - fr, flapT)
      ..quadraticBezierTo(flapR, flapT, flapR, flapT + fr)
      ..lineTo(flapR, flapB)
      ..lineTo(flapL, flapB)
      ..lineTo(flapL, flapT + fr)
      ..quadraticBezierTo(flapL, flapT, flapL + fr, flapT)
      ..close();

    canvas.drawPath(
      flapPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF2E5C1A), const Color(0xFF173808)],
        ).createShader(Rect.fromLTWH(flapL, flapT, flapR - flapL, flapB - flapT)),
    );

    // Flap edge highlight
    canvas.drawPath(
      flapPath,
      Paint()
        ..color = Colors.white.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ₹ symbol
    final tp = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.44,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: Colors.black.withOpacity(0.35), blurRadius: 6, offset: const Offset(1, 2))],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(w / 2 - tp.width / 2, h * 0.60 - tp.height / 2));
  }

  @override
  bool shouldRepaint(_WalletPainter _) => false;
}