import 'dart:async';
import 'package:flutter/material.dart';


class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _start = 90; // Default duration in seconds for 1:30 minutes
  bool _isRunning = false;

  void toggleTimer() {
    if (_isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    _isRunning = true;
    const oneSec = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any existing timers
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isRunning = false;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _start = 90;
      _isRunning = false;
    });
  }

  void setTime(int seconds) {
    setState(() {
      _start = seconds;
      _isRunning = false;
    });
  }

  String getFormattedTime() {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Color getButtonColor() {
    if (_isRunning) {
      return Colors.green; // Green when the timer is running
    } else if (_start != 90) {
      return Colors.orange; // Orange when paused
    } else {
      return Colors.amber[800]!; // Dark yellow when stopped
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 35),
            label: Text(
              getFormattedTime(),
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            onPressed: () => toggleTimer(),
            style: ElevatedButton.styleFrom(
              backgroundColor: getButtonColor(), // Correctly use backgroundColor instead of primary
              minimumSize: Size(200, 60), // Button size
              padding: EdgeInsets.zero, // No padding inside the button
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => resetTimer(),
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => showTimeSelection(context),
            child: Text('Set Duration'),
          ),
        ],
      );
  }

  void showTimeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('30 seconds'),
                onTap: () => {Navigator.pop(context), setTime(30)},
              ),
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('1:00 minute'),
                onTap: () => {Navigator.pop(context), setTime(60)},
              ),
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('1:30 minutes'),
                onTap: () => {Navigator.pop(context), setTime(90)},
              ),
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('2:00 minutes'),
                onTap: () => {Navigator.pop(context), setTime(120)},
              ),
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('3:00 minutes'),
                onTap: () => {Navigator.pop(context), setTime(180)},
              ),
            ],
          ),
        );
      },
    );
  }
}
