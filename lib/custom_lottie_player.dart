import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lottie_preview/lottie_frames.dart';

class LottiePlayer extends StatefulWidget {
  final LottieComposition composition;

  const LottiePlayer({Key? key, required this.composition}) : super(key: key);

  @override
  State<LottiePlayer> createState() => _LottiePlayerState();
}

class _LottiePlayerState extends State<LottiePlayer>
    with SingleTickerProviderStateMixin {
  late LottieDrawable drawable;
  late AnimationController controller;

  int get totalFrames =>
      (widget.composition.frameRate *
          widget.composition.duration.inMilliseconds) ~/
      1000;

  @override
  void initState() {
    drawable = LottieDrawable(widget.composition);
    controller =
        AnimationController(vsync: this, duration: widget.composition.duration);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            // size: Size(composition.bounds.width.toDouble(),
            //     composition.bounds.height.toDouble()),
            painter: LottiePainter(drawable, controller.value),
          );
        });
  }
}
