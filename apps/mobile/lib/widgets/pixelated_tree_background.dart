import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';

/// Animated pixelated tree background widget
/// Creates a dynamic halftone pattern effect
class PixelatedTreeBackground extends StatefulWidget {
  const PixelatedTreeBackground({super.key});

  @override
  State<PixelatedTreeBackground> createState() => _PixelatedTreeBackgroundState();
}

class _PixelatedTreeBackgroundState extends State<PixelatedTreeBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
          painter: PixelatedTreePainter(
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class PixelatedTreePainter extends CustomPainter {
  final double animationValue;

  PixelatedTreePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw gradient background
    final gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        KinnectColors.gradientStart,
        KinnectColors.background,
        KinnectColors.gradientEnd,
      ],
    );
    
    paint.shader = gradient.createShader(gradientRect);
    canvas.drawRect(gradientRect, paint);
    
    // Draw pixelated tree pattern
    _drawPixelatedPattern(canvas, size);
  }

  void _drawPixelatedPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42); // Fixed seed for consistency
    const cellSize = 4.0;
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();
    
    // Create tree-like pattern centered on screen
    final centerX = size.width / 2;
    final centerY = size.height / 3;
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * cellSize;
        final y = row * cellSize;
        
        // Calculate distance from center
        final dx = x - centerX;
        final dy = y - centerY;
        final distance = math.sqrt(dx * dx + dy * dy);
        
        // Create tree-like distribution
        final angle = math.atan2(dy, dx);
        final normalizedDistance = distance / (size.height / 2);
        
        // Branching pattern
        final branchFactor = math.sin(angle * 5 + animationValue * math.pi * 2) * 0.5 + 0.5;
        final treeFactor = (1 - normalizedDistance) * branchFactor;
        
        // Randomize with halftone effect
        final threshold = random.nextDouble() * 0.7;
        
        if (treeFactor > threshold) {
          // Calculate opacity based on distance and animation
          final opacity = (treeFactor * 0.6 + 
                         math.sin(animationValue * math.pi * 2 + distance * 0.01) * 0.2)
                         .clamp(0.0, 0.8);
          
          // Vary size slightly for organic feel
          final pixelSize = cellSize * (0.8 + random.nextDouble() * 0.4);
          
          paint.color = KinnectColors.textPrimary.withOpacity(opacity);
          
          canvas.drawRect(
            Rect.fromLTWH(
              x + (cellSize - pixelSize) / 2,
              y + (cellSize - pixelSize) / 2,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
    
    // Add some amber highlights
    _drawAmberHighlights(canvas, size, centerX, centerY);
  }

  void _drawAmberHighlights(Canvas canvas, Size size, double centerX, double centerY) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    final random = math.Random(123);
    
    for (int i = 0; i < 5; i++) {
      final angle = random.nextDouble() * math.pi * 2 + animationValue * math.pi;
      final distance = 100 + random.nextDouble() * 150;
      final x = centerX + math.cos(angle) * distance;
      final y = centerY + math.sin(angle) * distance;
      final size = 40 + random.nextDouble() * 60;
      
      paint.color = KinnectColors.accent.withOpacity(0.1 + random.nextDouble() * 0.1);
      
      canvas.drawCircle(
        Offset(x, y),
        size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(PixelatedTreePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
