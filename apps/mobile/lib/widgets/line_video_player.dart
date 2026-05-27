import 'package:flutter/widgets.dart';

import 'enhanced_video_player.dart';

/// Backward-compatible Line video player wrapper backed by real playback.
class LineVideoPlayer extends StatelessWidget {
  const LineVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoEnd,
    this.onDoubleTapLeft,
    this.onDoubleTapRight,
    this.onSingleTap,
    this.autoPlay = true,
    this.isCurrent = true,
  });

  final String videoUrl;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onDoubleTapLeft;
  final VoidCallback? onDoubleTapRight;
  final VoidCallback? onSingleTap;
  final bool autoPlay;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return EnhancedLineVideoPlayer(
      videoUrl: videoUrl,
      onVideoEnd: onVideoEnd,
      onDoubleTapLeft: onDoubleTapLeft,
      onDoubleTapRight: onDoubleTapRight,
      onSingleTap: onSingleTap,
      autoPlay: autoPlay,
      isCurrent: isCurrent,
    );
  }
}
