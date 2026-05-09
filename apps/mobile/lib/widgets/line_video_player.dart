import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';

/// Video player placeholder for The Line (web-compatible)
class LineVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onDoubleTapLeft;
  final VoidCallback? onDoubleTapRight;
  final VoidCallback? onSingleTap;
  final bool autoPlay;

  const LineVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoEnd,
    this.onDoubleTapLeft,
    this.onDoubleTapRight,
    this.onSingleTap,
    this.autoPlay = true,
  });

  @override
  State<LineVideoPlayer> createState() => _LineVideoPlayerState();
}

class _LineVideoPlayerState extends State<LineVideoPlayer> {
  bool _isPlaying = true;
  bool _showPulseAnimation = false;

  void _handleSingleTap() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    widget.onSingleTap?.call();
  }

  void _handleDoubleTapLeft() {
    widget.onDoubleTapLeft?.call();
  }

  void _handleDoubleTapRight() {
    setState(() {
      _showPulseAnimation = true;
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showPulseAnimation = false;
        });
      }
    });
    
    widget.onDoubleTapRight?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSingleTap,
      onDoubleTapDown: (details) {
        final width = MediaQuery.of(context).size.width;
        final tapX = details.localPosition.dx;
        
        if (tapX < width * 0.4) {
          _handleDoubleTapLeft();
        } else if (tapX > width * 0.6) {
          _handleDoubleTapRight();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video placeholder with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  KinnectColors.background,
                  KinnectColors.surface,
                  KinnectColors.background,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.play(),
                    size: 80,
                    color: KinnectColors.accent.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Video Player',
                    style: TextStyle(
                      color: KinnectColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to pause � Double tap to pulse',
                    style: TextStyle(
                      color: KinnectColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pulse animation overlay
          if (_showPulseAnimation)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1.5),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: 1.0 - (value - 0.5),
                      child: Icon(
                        Icons.favorite,
                        size: 100,
                        color: KinnectColors.error.withOpacity(0.8),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Pause indicator
          if (!_isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get isPlaying => _isPlaying;
}
