import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/colors.dart';

class VoiceWaveform extends StatefulWidget {
  final bool isRecording;
  final Duration duration;

  const VoiceWaveform({
    super.key,
    required this.isRecording,
    required this.duration,
  });

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<double> _amplitudes = List.generate(50, (_) => 0.2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        if (widget.isRecording) {
          setState(() {
            _amplitudes.removeAt(0);
            _amplitudes.add(0.2 + _random.nextDouble() * 0.8);
          });
        }
      });
  }

  @override
  void didUpdateWidget(VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _controller.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        painter: WaveformPainter(
          amplitudes: _amplitudes,
          color: widget.isRecording ? KinnectColors.amber : KinnectColors.grey40,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  WaveformPainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / amplitudes.length;
    final centerY = size.height / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * barWidth;
      final barHeight = amplitudes[i] * size.height / 2;

      canvas.drawLine(
        Offset(x, centerY - barHeight),
        Offset(x, centerY + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) =>
      amplitudes != oldDelegate.amplitudes || color != oldDelegate.color;
}
