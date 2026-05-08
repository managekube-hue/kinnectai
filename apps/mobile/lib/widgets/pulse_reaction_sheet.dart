import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PulseReactionSheet extends StatefulWidget {
  final String memoryId;
  final Function(bool) onPulseToggle;
  
  const PulseReactionSheet({
    super.key,
    required this.memoryId,
    required this.onPulseToggle,
  });

  @override
  State<PulseReactionSheet> createState() => _PulseReactionSheetState();
}

class _PulseReactionSheetState extends State<PulseReactionSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPulsed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: GestureDetector(
          onTap: _togglePulse,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isPulsed ? KinnectColors.error : KinnectColors.textMuted,
                    shape: BoxShape.circle,
                    boxShadow: _isPulsed
                        ? [
                            BoxShadow(
                              color: KinnectColors.error.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    _isPulsed ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _togglePulse() {
    setState(() => _isPulsed = !_isPulsed);
    _controller.forward().then((_) => _controller.reverse());
    widget.onPulseToggle(_isPulsed);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context);
    });
  }
}
