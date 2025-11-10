import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipTag extends StatefulWidget {
  final List<String> texts;
  const FlipTag({super.key, required this.texts});

  @override
  State<FlipTag> createState() => _FlipTagState();
}

class _FlipTagState extends State<FlipTag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _startFlipping();
  }

  void _startFlipping() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted) {
            setState(() {
              _currentIndex = (_currentIndex + 1) % widget.texts.length;
            });
            _controller.reset();
            _startFlipping();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        final isShowingFront = _rotationAnimation.value <= math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_rotationAnimation.value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isShowingFront 
                  ? widget.texts[_currentIndex]
                  : widget.texts[(_currentIndex + 1) % widget.texts.length],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
