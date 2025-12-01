import 'package:flutter/material.dart';
import '../Utility/app_images.dart';

class RotatingRefreshIcon extends StatefulWidget {
  final double size;

  const RotatingRefreshIcon({super.key, this.size = 15});

  @override
  RotatingRefreshIconState createState() => RotatingRefreshIconState();
}

class RotatingRefreshIconState extends State<RotatingRefreshIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  void spin() {
    if (!mounted) return;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
      child: Icon(
        Icons.refresh,
        size: widget.size,
        weight: 900, // ← THIS MAKES IT THICK
      ),
      // child: Image.asset(
      //   AppImages.refresh,
      //   height: widget.size,
      //
      // ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
