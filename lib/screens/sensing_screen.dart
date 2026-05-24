import 'package:flutter/material.dart';
import 'dart:math';

class SensingScreen extends StatefulWidget {
  const SensingScreen({super.key});

  @override
  State<SensingScreen> createState() => _SensingScreenState();
}

class _SensingScreenState extends State<SensingScreen> with SingleTickerProviderStateMixin {
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live WiFi Sensing Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _SignalPainter(_controller.value),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'RSSI Metrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricGraph('Antenna 1 (TX)', Colors.blue, 0.2),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricGraph('Antenna 2 (RX1)', Colors.green, 0.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricGraph('Antenna 3 (RX2)', Colors.orange, 0.8),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricGraph('Variance / Noise', Colors.red, 0.1),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricGraph(String title, Color color, double phaseOffset) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: _SparklinePainter(_controller.value, color, phaseOffset),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalPainter extends CustomPainter {
  final double animationValue;

  _SignalPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final centerY = size.height / 2;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw multiple sine waves to simulate WiFi subcarriers
    for (int j = 0; j < 5; j++) {
      paint.color = HSLColor.fromAHSL(0.7, (j * 72.0) % 360, 1.0, 0.5).toColor();

      final path = Path();
      bool first = true;

      for (double x = 0; x < size.width; x += 5) {
        final normalizedX = x / size.width;
        // Combine a few sine waves for complex signal look
        final y1 = sin((normalizedX * 4 * pi) + (animationValue * 2 * pi) + (j * 0.5)) * 30;
        final y2 = cos((normalizedX * 8 * pi) - (animationValue * pi)) * 15;
        final y3 = sin((normalizedX * 16 * pi) + (animationValue * 4 * pi)) * 5;

        final y = centerY + y1 + y2 + y3;

        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignalPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _SparklinePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double phaseOffset;

  _SparklinePainter(this.animationValue, this.color, this.phaseOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    bool first = true;

    for (double x = 0; x < size.width; x += 2) {
      final normalizedX = x / size.width;

      // Generate some pseudo-random but continuous data for the sparkline
      // We use sine waves with offsets to make it look like scrolling data
      final baseSine = sin((normalizedX * 10 * pi) - (animationValue * 2 * pi) + phaseOffset);
      final noise = sin((normalizedX * 50 * pi) + (animationValue * 5 * pi)) * 0.2;

      // Map from [-1.2, 1.2] to [0, height]
      final value = (baseSine + noise) / 1.2;
      final y = size.height / 2 - (value * size.height / 2.5);

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
