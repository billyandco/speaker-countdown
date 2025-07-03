import 'dart:math';
import 'package:flutter/material.dart';

class AnalogClockPainter extends CustomPainter {
  final DateTime dateTime;
  final bool showDigitalClock;
  final Color dialColor;
  final Color handColor;
  final Color secondHandColor;
  final Color numberColor;
  final Color tickColor;

  AnalogClockPainter({
    required this.dateTime,
    this.showDigitalClock = true,
    this.dialColor = Colors.white,
    this.handColor = Colors.black,
    this.secondHandColor = Colors.redAccent,
    this.numberColor = Colors.black,
    this.tickColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 0.85;

    // Dial
    final dialPaint = Paint()..color = dialColor;
    canvas.drawCircle(center, radius, dialPaint);

    final borderPaint = Paint()
      ..color = handColor // Use handColor for border for consistency
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);
    canvas.drawCircle(center, radius * 0.05, Paint()..color = handColor); // Center dot


    // Hour, Minute, Second and Ticks
    for (int i = 0; i < 60; i++) {
      final angle = (i / 60) * 2 * pi - pi / 2;
      final isHourMark = i % 5 == 0;
      final tickLength = isHourMark ? radius * 0.1 : radius * 0.05;
      final tickPaint = Paint()
        ..color = tickColor
        ..strokeWidth = isHourMark ? 2 : 1;

      final startX = center.dx + (radius - tickLength) * cos(angle);
      final startY = center.dy + (radius - tickLength) * sin(angle);
      final endX = center.dx + radius * cos(angle);
      final endY = center.dy + radius * sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);

      // Numbers
      if (isHourMark) {
        final hour = (i ~/ 5 == 0) ? 12 : (i ~/ 5);
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$hour',
            style: TextStyle(color: numberColor, fontSize: radius * 0.15),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textX = center.dx + (radius * 0.75) * cos(angle) - textPainter.width / 2;
        final textY = center.dy + (radius * 0.75) * sin(angle) - textPainter.height / 2;
        textPainter.paint(canvas, Offset(textX, textY));
      }
    }

    // Hands
    final hour = dateTime.hour % 12 + dateTime.minute / 60;
    final minute = dateTime.minute + dateTime.second / 60;
    final second = dateTime.second.toDouble();

    // Hour Hand
    final hourHandPaint = Paint()
      ..color = handColor
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;
    final hourHandAngle = (hour / 12) * 2 * pi - pi / 2;
    final hourHandX = center.dx + radius * 0.5 * cos(hourHandAngle);
    final hourHandY = center.dy + radius * 0.5 * sin(hourHandAngle);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Minute Hand
    final minuteHandPaint = Paint()
      ..color = handColor
      ..strokeWidth = radius * 0.03
      ..strokeCap = StrokeCap.round;
    final minuteHandAngle = (minute / 60) * 2 * pi - pi / 2;
    final minuteHandX = center.dx + radius * 0.7 * cos(minuteHandAngle);
    final minuteHandY = center.dy + radius * 0.7 * sin(minuteHandAngle);
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    // Second Hand
    final secondHandPaint = Paint()
      ..color = secondHandColor
      ..strokeWidth = radius * 0.02
      ..strokeCap = StrokeCap.round;
    final secondHandAngle = (second / 60) * 2 * pi - pi / 2;
    final secondHandX = center.dx + radius * 0.8 * cos(secondHandAngle);
    final secondHandY = center.dy + radius * 0.8 * sin(secondHandAngle);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);
     // Center dot (drawn again on top of hands)
    canvas.drawCircle(center, radius * 0.05, Paint()..color = handColor);
  }

  @override
  bool shouldRepaint(covariant AnalogClockPainter oldDelegate) {
    return oldDelegate.dateTime != dateTime ||
           oldDelegate.showDigitalClock != showDigitalClock ||
           oldDelegate.dialColor != dialColor ||
           oldDelegate.handColor != handColor ||
           oldDelegate.secondHandColor != secondHandColor ||
           oldDelegate.numberColor != numberColor ||
           oldDelegate.tickColor != tickColor;
  }
}
