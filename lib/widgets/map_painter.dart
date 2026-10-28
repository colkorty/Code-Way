import 'package:flutter/material.dart';

class MapPainter extends CustomPainter {
    final int count;
    final Color lineColor;
    final double itemHeight;
    final double nodeSize;
    final double sideOffset;

    MapPainter({
        required this.count,
        required this.lineColor,
        this.itemHeight = 180.0,
        this.nodeSize = 70.0,
        this.sideOffset = 90.0,
    });

    @override
    void paint(Canvas canvas, Size size) {
        if (count <= 1) return;

        final paint = Paint()
            ..color = lineColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round;

        for (int i = 0; i < count - 1; i++) {
            final startX = size.width / 2 +
                (i.isEven ? -sideOffset : sideOffset);
            final endX = size.width / 2 +
                (i.isEven ? sideOffset : -sideOffset);
            final startY = i * itemHeight + nodeSize / 2;
            final arrowTipY = (i + 1) * itemHeight - 10;
            final direction = endX > startX ? 1.0 : -1.0;

            final route = Path()
                ..moveTo(startX + direction * nodeSize / 2, startY)
                ..lineTo(endX, startY)
                ..lineTo(endX, arrowTipY - 9);

            canvas.drawPath(_createDashedPath(route), paint);

            final arrow = Path()
                ..moveTo(endX - 6, arrowTipY - 8)
                ..lineTo(endX, arrowTipY)
                ..lineTo(endX + 6, arrowTipY - 8);
            canvas.drawPath(arrow, paint);
        }
    }

    Path _createDashedPath(Path path) {
        const dashLength = 8.0;
        const gapLength = 7.0;
        final dashedPath = Path();

        for (final metric in path.computeMetrics()) {
            var distance = 0.0;
            while (distance < metric.length) {
                final end = (distance + dashLength).clamp(0.0, metric.length);
                dashedPath.addPath(
                    metric.extractPath(distance, end),
                    Offset.zero,
                );
                distance += dashLength + gapLength;
            }
        }

        return dashedPath;
    }

    @override
    bool shouldRepaint(covariant MapPainter oldDelegate) {
        return oldDelegate.count != count ||
            oldDelegate.lineColor != lineColor ||
            oldDelegate.itemHeight != itemHeight ||
            oldDelegate.nodeSize != nodeSize ||
            oldDelegate.sideOffset != sideOffset;
    }
}