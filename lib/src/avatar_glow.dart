import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that adds a glowing effect around its child.
class AvatarGlow extends StatefulWidget {
  /// Creates an [AvatarGlow] widget.
  const AvatarGlow({
    Key? key,
    required this.child,
    this.glowCount = 2,
    this.glowColor = Colors.white,
    this.glowShape = BoxShape.circle,
    this.glowBorderRadius,
    this.duration = const Duration(seconds: 2),
    this.startDelay,
    this.animate = true,
    this.repeat = true,
    this.curve = Curves.fastOutSlowIn,
    this.glowRadiusFactor = 0.7,
    this.strokeWidth,
    this.paintingStyle,
    this.linearGradient,
  })  : assert(
          glowShape != BoxShape.circle || glowBorderRadius == null,
          'Cannot specify a border radius if the shape is a circle.',
        ),
        super(key: key);

  /// The child widget to display inside the glowing effect.
  final Widget child;

  /// The number of glowing effects to show around the child.
  final int glowCount;

  /// The color of the glow effect.
  final Color glowColor;

  /// The shape of the glow effect.
  final BoxShape glowShape;

  /// The border radius for the glow effect.
  final BorderRadius? glowBorderRadius;

  /// The duration of the glowing animation.
  final Duration duration;

  /// The delay before starting the glowing animation.
  final Duration? startDelay;

  /// Whether to animate the glowing effect.
  final bool animate;

  /// Whether to repeat the glowing animation.
  final bool repeat;

  /// The curve for the glowing animation.
  final Curve curve;

  /// The factor that determines the size of each glow effect relative to the original size.
  final double glowRadiusFactor;

  /// How wide to make edges drawn when [style] is set to [PaintingStyle.stroke]. The width is given in logical pixels measured in the direction orthogonal to the direction of the path.
  final double? strokeWidth;

  /// Whether to paint inside shapes, the edges of shapes, or both.
  final PaintingStyle? paintingStyle;

  /// A 2D gradient.
  final LinearGradient? linearGradient;

  @override
  State<AvatarGlow> createState() => _AvatarGlowState();
}

class _AvatarGlowState extends State<AvatarGlow>
    with SingleTickerProviderStateMixin<AvatarGlow> {
  late final AnimationController _controller;
  late final _GlowPainter _painter;
  late final Tween<double> _opacityTween = Tween<double>(begin: 0.3, end: 0);

  void _startAnimation() async {
    final startDelay = widget.startDelay;
    if (startDelay != null) {
      await Future.delayed(startDelay);
    }

    // Check if the widget is still mounted before starting the animation.
    if (mounted) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  void _stopAnimation() {
    // Wait for the animation to finish before stopping it.
    _controller.reverse().then((_) {
      // Check if the widget is still mounted before stopping the animation.
      if (mounted) {
        _controller.stop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _painter = _GlowPainter(progress: _controller);

    if (widget.animate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AvatarGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }

    if (widget.repeat != oldWidget.repeat) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _painter
          ..curve = widget.curve
          ..opacityTween = _opacityTween
          ..glowCount = widget.glowCount
          ..strokeWidth = widget.strokeWidth
          ..paintingStyle = widget.paintingStyle
          ..linearGradient = widget.linearGradient
          ..glowDecoration = BoxDecoration(
            color: widget.glowColor,
            shape: widget.glowShape,
            borderRadius: widget.glowBorderRadius,
          )
          ..glowRadiusFactor = widget.glowRadiusFactor,
        child: widget.child,
      ),
    );
  }
}

class _GlowPainter extends ChangeNotifier implements CustomPainter {
  _GlowPainter({required this.progress}) {
    progress.addListener(notifyListeners);
  }

  final Animation<double> progress;

  Curve get curve => _curve!;
  Curve? _curve;

  set curve(Curve value) {
    if (_curve != value) {
      _curve = value;
      notifyListeners();
    }
  }

  Tween<double> get opacityTween => _opacityTween!;
  Tween<double>? _opacityTween;

  set opacityTween(Tween<double> value) {
    if (_opacityTween != value) {
      _opacityTween = value;
      notifyListeners();
    }
  }

  int get glowCount => _glowCount!;
  int? _glowCount;

  set glowCount(int value) {
    if (_glowCount != value) {
      _glowCount = value;
      notifyListeners();
    }
  }

  double? get strokeWidth => _strokeWidth;
  double? _strokeWidth;

  set strokeWidth(double? value) {
    if (value != null && _strokeWidth != value) {
      _strokeWidth ??= value;
      notifyListeners();
    }
  }

  PaintingStyle? get paintingStyle => _paintingStyle;
  PaintingStyle? _paintingStyle;

  set paintingStyle(PaintingStyle? value) {
    if (value != null && _paintingStyle != value) {
      _paintingStyle ??= value;
      notifyListeners();
    }
  }

  LinearGradient? get linearGradient => _linearGradient;
  LinearGradient? _linearGradient;

  set linearGradient(LinearGradient? value) {
    if (value != null && _linearGradient != value) {
      _linearGradient ??= value;
    }
  }

  BoxDecoration get glowDecoration => _glowDecoration!;
  BoxDecoration? _glowDecoration;

  set glowDecoration(BoxDecoration value) {
    if (_glowDecoration != value) {
      _glowDecoration = value;
      notifyListeners();
    }
  }

  double get glowRadiusFactor => _glowRadiusFactor!;
  double? _glowRadiusFactor;

  set glowRadiusFactor(double value) {
    if (_glowRadiusFactor != value) {
      _glowRadiusFactor = value;
      notifyListeners();
    }
  }

  // We cache the path so that we don't have to recreate it
  // every time we paint.
  final Path _glowPath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    double radius =
        math.min(size.width, size.height) / 2 - (strokeWidth ?? 0) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    final glowColor = glowDecoration.color!;
    final opacity = opacityTween.evaluate(progress);

    final paint = Paint()
      ..color = glowColor.withOpacity(opacity)
      ..shader = _linearGradient?.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    if (strokeWidth != null) {
      paint.strokeWidth = strokeWidth!;
    }
    if (paintingStyle != null) {
      paint.style = paintingStyle!;
    }

    final glowSize = math.min(size.width, size.height);
    final glowRadius = glowSize / 2;

    final currentProgress = curve.transform(progress.value);

    // Cache the path and reuse it for each glow.
    _glowPath.reset();

    // We need to draw the glows from the smallest to the largest.
    for (int i = 1; i <= glowCount; i++) {
      final currentRadius =
          radius + glowRadius * glowRadiusFactor * i * currentProgress;

      final currentRect = Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: currentRadius,
      );

      _addGlowPath(currentRect);
      canvas.drawPath(_glowPath, paint);
    }
  }

  void _addGlowPath(Rect glowRect) {
    _glowPath.addPath(
      glowDecoration.getClipPath(
        glowRect,
        TextDirection.ltr,
      ),
      Offset.zero,
    );
  }

  @override
  void dispose() {
    progress.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  String toString() => describeIdentity(this);
}
