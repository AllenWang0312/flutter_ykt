import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class PuzzlePage extends StatefulWidget {
  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  StreamController _inputController = StreamController.broadcast();
  StreamController _scoreController = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: _scoreController.stream.transform(TallyTransformer()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("Score: ${snapshot.data}");
            } else {
              return Text("Score: 0");
            }
          },
        ),
      ),
      body: Stack(
        children: [
          ...List.generate(
              4, (index) => Puzzle(_inputController.stream, _scoreController)),
          Align(
            alignment: Alignment.bottomCenter,
            child: KeyPad(_inputController),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    //页面销毁
    _inputController.close(); //关闭数据流
    super.dispose();
  }
}

class TallyTransformer implements StreamTransformer {
  int sum = 0;
  StreamController _controller = StreamController();

  @override
  Stream bind(Stream stream) {
    stream.listen((event) {
      if(null!=event)sum += (event as int);
      _controller.add(sum);
    });
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}

class KeyPad extends StatelessWidget {
 late StreamController _controller;

  KeyPad(StreamController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      //不要占满空间
      shrinkWrap: true,
      //去掉底部为手势留的区域
      padding: EdgeInsets.all(0.0),
      //不可滑动
      physics: NeverScrollableScrollPhysics(),
      //限制宽高比
      childAspectRatio: 2 / 1,
      children: List.generate(9, (index) {
        return MaterialButton(
            //去掉默认圆角
            shape: const RoundedRectangleBorder(),
            color: Colors.primaries[index][200],
            child: Text(
              "${index + 1}",
              style: const TextStyle(fontSize: 24),
            ),
            onPressed: () {
              _controller.add(index + 1);
            });
      }),
    );
  }
}

class Puzzle extends StatefulWidget {
  final inputStream;
  final scoreStream;

  Puzzle(this.inputStream, this.scoreStream);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  late int a, b;
  late Color color;
  late double x;
  late AnimationController _controller;

  reset([from = 0.0]) {
    a = Random().nextInt(5) + 1;
    b = Random().nextInt(5);
    x = Random().nextDouble() * 300;
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)]![200]!;

    _controller.duration =
        Duration(milliseconds: Random().nextInt(5000) + 5000);
    _controller.forward(from: from);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    reset(Random().nextDouble());

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        reset();
        widget.scoreStream.add(-2);
      }
    });
    widget.inputStream.listen((event) {
      if (event == a + b) {
        reset();
        widget.scoreStream.add(5);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: x,
          top: 400 * _controller.value,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Text(
              "$a+$b",
              style: TextStyle(fontSize: 28.0),
            ),
          ),
        );
      },
    );
  }
}
