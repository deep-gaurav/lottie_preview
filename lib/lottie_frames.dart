import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieFrames extends StatelessWidget {
  final LottieComposition composition;

  const LottieFrames({Key? key, required this.composition}) : super(key: key);

  int get totalFrames =>
      (composition.frameRate * composition.duration.inMilliseconds ~/ 1000);

  @override
  Widget build(BuildContext context) {
    var drawable = LottieDrawable(composition);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frames'),
      ),
      body: Wrap(
        children: [
          ...List.generate(totalFrames, (index) => index).map(
            (e) => CustomPaint(
              size: Size(composition.bounds.width.toDouble(),
                  composition.bounds.height.toDouble()),
              painter: LottiePainter(drawable, e / totalFrames),
            ),
          )
        ],
      ),
    );
  }
}

class LottiePainter extends CustomPainter {
  final LottieDrawable drawable;
  final double frame;

  LottiePainter(this.drawable, this.frame);

  @override
  void paint(Canvas canvas, Size size) {
    drawable
      ..setProgress(frame)
      ..draw(
        canvas,
        Rect.fromLTRB(0, 0, size.width, size.height),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}