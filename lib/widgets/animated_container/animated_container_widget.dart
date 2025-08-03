import 'package:flutter/material.dart';

class AnimatedMoodContainerWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final Offset offset;

  const AnimatedMoodContainerWidget({
    super.key,
    required this.child,
    required this.index,
    required this.offset,
  });

  @override
  State<AnimatedMoodContainerWidget> createState() => _AnimatedMoodContainerWidgetState();
}

class _AnimatedMoodContainerWidgetState extends State<AnimatedMoodContainerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _offSetAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final curve = CurvedAnimation(parent: _controller!, curve: Curves.easeOut);

    _offSetAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curve);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      _controller?.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeAnimation == null || _offSetAnimation == null) {
      return const SizedBox.shrink();
    } else {
      return FadeTransition(
        opacity: _fadeAnimation!,
        child: SlideTransition(
          position: _offSetAnimation!,
          child:  widget.child,
        ),
      );
    }
  }
}
