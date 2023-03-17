import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lottie_preview/lottie_frames.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lottie Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Lottie Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
            ),
            TextField(
              controller: controller2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                lottie1: controller.text,
                lottie2: controller2.text.isEmpty
                    ? controller.text
                    : controller2.text,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    Key? key,
    required this.lottie1,
    required this.lottie2,
  }) : super(key: key);

  final String lottie1;
  final String lottie2;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool flip = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: Center(
        child: AnimatedSwitcher(
          key: const Key("CardSwitcher"),
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (child, animation) => flipTransition(
            child,
            animation,
            Key(flip ? '1' : '2'),
          ),
          child: (flip
              ? Lottie.memory(
                  const Utf8Encoder().convert(widget.lottie1),
                  key: const Key('1'),
                )
              : Lottie.memory(
                  const Utf8Encoder().convert(widget.lottie2),
                  key: const Key('2'),
                )),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.change_circle),
            onPressed: () async {
              setState(() {
                flip = !flip;
              });
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () async {
              var nav = Navigator.of(context);
              var composition = await LottieComposition.fromBytes(
                  const Utf8Encoder().convert(widget.lottie1));
              nav.push(
                MaterialPageRoute(
                  builder: (context) => LottieFrames(composition: composition),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget flipTransition(Widget child, Animation<double> animation, Key key) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      if (child!.key != null && child.key == key) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY((1 - animation.value) * -pi),
          child: animation.value >= 0.5 ? child : Container(),
        );
      } else {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(pi * (1 - animation.value)),
          child: animation.value >= 0.5 ? child : Container(),
        );
      }
    },
    child: child,
  );
}
