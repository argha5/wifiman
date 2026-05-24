import 'package:flutter/material.dart';
import 'dart:math';

class LiveDemoScreen extends StatefulWidget {
  const LiveDemoScreen({super.key});

  @override
  State<LiveDemoScreen> createState() => _LiveDemoScreenState();
}

class _LiveDemoScreenState extends State<LiveDemoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Pose Estimation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Model Inference',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
                      painter: _SkeletonPainter(_controller.value),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Estimation setup: 4+ ESP32 Nodes (Simulated)',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPainter extends CustomPainter {
  final double animationValue;

  _SkeletonPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Center the skeleton
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Add some walking/moving animation logic
    // Using animationValue (0.0 to 1.0)
    final swing = sin(animationValue * pi);

    // Keypoints
    final head = Offset(centerX, centerY - 100 + swing * 5);
    final neck = Offset(centerX, centerY - 60 + swing * 5);

    final leftShoulder = Offset(centerX - 40, centerY - 60);
    final rightShoulder = Offset(centerX + 40, centerY - 60);

    final leftElbow = Offset(centerX - 50 - swing * 10, centerY - 10 - swing * 20);
    final rightElbow = Offset(centerX + 50 + swing * 10, centerY - 10 + swing * 20);

    final leftWrist = Offset(centerX - 45 - swing * 20, centerY + 30 - swing * 30);
    final rightWrist = Offset(centerX + 45 + swing * 20, centerY + 30 + swing * 30);

    final pelvis = Offset(centerX, centerY + 20 + swing * 5);

    final leftHip = Offset(centerX - 25, centerY + 20);
    final rightHip = Offset(centerX + 25, centerY + 20);

    final leftKnee = Offset(centerX - 25 + swing * 15, centerY + 90 - swing * 20);
    final rightKnee = Offset(centerX + 25 - swing * 15, centerY + 90 + swing * 20);

    final leftAnkle = Offset(centerX - 25 + swing * 30, centerY + 160 - swing * 40);
    final rightAnkle = Offset(centerX + 25 - swing * 30, centerY + 160 + swing * 40);

    // Draw lines connecting keypoints (bones)
    void drawBone(Offset p1, Offset p2) {
      canvas.drawLine(p1, p2, paint);
    }

    drawBone(head, neck);
    drawBone(neck, leftShoulder);
    drawBone(neck, rightShoulder);
    drawBone(neck, pelvis);

    drawBone(leftShoulder, leftElbow);
    drawBone(leftElbow, leftWrist);

    drawBone(rightShoulder, rightElbow);
    drawBone(rightElbow, rightWrist);

    drawBone(pelvis, leftHip);
    drawBone(pelvis, rightHip);

    drawBone(leftHip, leftKnee);
    drawBone(leftKnee, leftAnkle);

    drawBone(rightHip, rightKnee);
    drawBone(rightKnee, rightAnkle);

    // Draw joints (points)
    final points = [
      head, neck, leftShoulder, rightShoulder, leftElbow, rightElbow,
      leftWrist, rightWrist, pelvis, leftHip, rightHip, leftKnee, rightKnee,
      leftAnkle, rightAnkle
    ];

    for (var point in points) {
      canvas.drawCircle(point, 6.0, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SkeletonPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
