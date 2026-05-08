import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';

/// Animated sparkle icon widget
/// Shows rotating 3-star animation
class SparkleIcon extends StatefulWidget {
  final double size;
  
  const SparkleIcon({
    super.key,
    this.size = 80.0,
  });

  @override
  State<SparkleIcon> createState() => _SparkleIconState();
}

class _SparkleIconState extends State<SparkleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SparklePainter(
            animationValue: _controller.value,
          ),
          size: Size(widget.size, widget.size),
        );
      },
    );
  }
}

class SparklePainter extends CustomPainter {
  final double animationValue;

  SparklePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw circular background with gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          KinnectColors.accent.withOpacity(0.3),
          KinnectColors.accent.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    
    canvas.drawCircle(center, size.width / 2, bgPaint);
    
    // Draw three sparkle stars
    _drawStar(canvas, center, size.width * 0.25, animationValue * math.pi * 2, 1.0);
    _drawStar(canvas, center, size.width * 0.15, animationValue * math.pi * 2 + math.pi * 0.7, 0.7);
    _drawStar(canvas, center, size.width * 0.12, animationValue * math.pi * 2 + math.pi * 1.3, 0.5);
  }

  void _drawStar(Canvas canvas, Offset center, double size, double rotation, double opacity) {
    final paint = Paint()
      ..color = KinnectColors.accent.withOpacity(opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    final path = Path();
    final points = 4; // 4-pointed star
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) + rotation;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // Draw inner glow
    final glowPaint = Paint()
      ..color = KinnectColors.textPrimary.withOpacity(opacity * 0.8)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawCircle(center, size * 0.2, glowPaint);
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
