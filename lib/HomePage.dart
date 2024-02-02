import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleStartStop() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _stopwatch.start();
        _controller.forward();
      } else {
        _stopwatch.stop();
        _controller.reverse();
      }
    });
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {});
  }

  String _getFormattedText() {
    final milliseconds = _stopwatch.elapsedMilliseconds;
    final String hundredths = ((milliseconds ~/ 10) % 100).toString().padLeft(2, "0");
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, "0");
    final minutes = ((milliseconds ~/ (1000 * 60)) % 60).toString().padLeft(2, "0");

    return "$minutes:$seconds:$hundredths";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleStartStop,
                child: RotationTransition(
                  turns: _animation,
                  child: Container(
                    height: 250,
                    width: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 4,
                      ),
                      gradient: RadialGradient(
                        colors: [Colors.blue.withOpacity(0.8), Colors.blue.withOpacity(0.5)],
                      ),
                    ),
                    child: Text(
                      _getFormattedText(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
