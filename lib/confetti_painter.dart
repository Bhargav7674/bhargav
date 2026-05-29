import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiParticle {
  final double x, vx, vy, rotationSpeed, size;
  final bool isRect;
  final Color color;
  double y, rotation;

  ConfettiParticle({
    required this.x, required this.y,
    required this.vx, required this.vy,
    required this.color, required this.rotation,
    required this.rotationSpeed, required this.size,
    required this.isRect,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  const ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final t = progress * 60; // scale to ~60 frames
    for (final p in particles) {
      final px = (p.x + p.vx * t) * size.width;
      final py = (p.y + p.vy * t + 0.0003 * t * t) * size.height;
      if (py > size.height + 30 || py < -30) continue;
      final opacity = (1.0 - progress * 0.7).clamp(0.0, 1.0);
      final paint = Paint()..color = p.color.withOpacity(opacity);
      final rot = p.rotation + p.rotationSpeed * t;
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rot);
      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.42),
          paint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size * 0.45, height: p.size),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => old.progress != progress;
}