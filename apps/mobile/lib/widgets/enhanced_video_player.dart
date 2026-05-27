import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:video_player/video_player.dart';
import '../theme/colors.dart';

/// Enhanced video player with real playback controls
class EnhancedLineVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onDoubleTapLeft;
  final VoidCallback? onDoubleTapRight;
  final VoidCallback? onSingleTap;
  final bool autoPlay;
  final bool isCurrent;

  const EnhancedLineVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoEnd,
    this.onDoubleTapLeft,
    this.onDoubleTapRight,
    this.onSingleTap,
    this.autoPlay = true,
    this.isCurrent = false,
  });

  @override
  State<EnhancedLineVideoPlayer> createState() => _EnhancedLineVideoPlayerState();
}

class _EnhancedLineVideoPlayerState extends State<EnhancedLineVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showPulseAnimation = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(EnhancedLineVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reinitialize if video URL changes
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _initializeVideo();
    }
    
    // Handle play/pause based on current state
    if (oldWidget.isCurrent != widget.isCurrent) {
      if (widget.isCurrent && _isInitialized) {
        _controller?.play();
      } else if (!widget.isCurrent && _isInitialized) {
        _controller?.pause();
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      // Support both network and asset videos
      if (widget.videoUrl.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      } else {
        _controller = VideoPlayerController.asset(widget.videoUrl);
      }
      
      await _controller!.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isInitialized = true;
        _hasError = false;
      });
      
      // Set looping
      _controller!.setLooping(true);
      
      // Auto-play if enabled and current
      if (widget.autoPlay && widget.isCurrent) {
        _controller!.play();
      }
      
      // Listen for video completion
      _controller!.addListener(_videoListener);
      
    } catch (e) {
      debugPrint('? Video initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    // Check if video ended
    if (_controller!.value.position >= _controller!.value.duration) {
      widget.onVideoEnd?.call();
    }
  }

  void _disposeController() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _handleSingleTap() {
    if (!_isInitialized || _controller == null) return;
    
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
    
    widget.onSingleTap?.call();
  }

  void _handleDoubleTapLeft() {
    if (!_isInitialized || _controller == null) return;
    
    // Rewind 10 seconds
    final currentPosition = _controller!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller!.seekTo(newPosition >= Duration.zero ? newPosition : Duration.zero);
    
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
          // Video player with loading/error fallback states
          if (_hasError)
            _buildErrorState()
          else if (!_isInitialized)
            _buildLoadingState()
          else
            _buildVideoPlayer(),
          
          // Pulse animation overlay
          if (_showPulseAnimation) _buildPulseAnimation(),
          
          // Play/Pause indicator
          if (_isInitialized && _controller != null && !_controller!.value.isPlaying)
            _buildPauseIndicator(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: KinnectColors.background,
      child: const Center(
        child: CircularProgressIndicator(
          color: KinnectColors.accent,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            KinnectColors.background,
            KinnectColors.surface,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.warningCircle(),
              size: 80,
              color: KinnectColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load video',
              style: TextStyle(
                color: KinnectColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseAnimation() {
    return Center(
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
    );
  }

  Widget _buildPauseIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          PhosphorIcons.play(),
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
