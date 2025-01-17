import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quiet/component/global/settings.dart';

///版权说明浮层
class CopyRightOverlay extends HookWidget {
  const CopyRightOverlay({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final _painter = useMemoized(() => _CopyrightPainter());
    return CustomPaint(
      foregroundPainter:
          Settings.of(context).showCopyrightOverlay ? null : _painter,
      child: child,
    );
  }
}

class _CopyrightPainter extends CustomPainter {
  final TextPainter _textPainter = TextPainter(
      text: TextSpan(
        text:
            "只用作个人学习研究，禁止用于商业及非法用途 Only used for personal study and research, commercial and illegal purposes are prohibited",
        style: TextStyle(color: Colors.grey.withOpacity(0.3)),
      ),
      textDirection: TextDirection.ltr);

  bool _dirty = true;

  static const double radius = math.pi / 4;

  @override
  void paint(Canvas canvas, Size size) {
    if (_dirty) {
      _textPainter.layout();
      _dirty = false;
    }
    canvas.rotate(-radius);

    double dy = 0;
    while (dy < size.height) {
      canvas.save();
      final double dx = dy * math.tan(radius);
      canvas.translate(-dx, dy);
      _textPainter.paint(canvas, Offset.zero);
      dy += _textPainter.height * 3;
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
