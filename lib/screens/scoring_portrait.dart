import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class ScoringPortrait extends StatefulWidget {
  @override
  _ScoringPageState createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPortrait> {
  var _timer;
  int _matchTime = 90;
  int _current = 90;

  String _pausePlay = "play";
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];

  @override
  initState() {
    super.initState();
  }


  IconData getTimerIcon(String pause) {
    if (pause == "pause") {
      return Icons.pause;
    } else {
      return Icons.play_arrow;
    }
  }

  void startTimer(reset) {
    if (_timer != null) {
      // Pause timer
      setState(() {
        _pausePlay = "play";
        _containerColor = Colors.deepOrangeAccent;
      });
      _timer.cancel();
      _timer = null;
    } else {
      if (reset) {
        // Restart timer
        setState(() {
          _pausePlay = "play";
          _containerColor = Colors.green;
          _current = _matchTime;
        });
      } else {
        // Start timer
        _timer = new Timer.periodic(
          const Duration(seconds: 1),
          (Timer timer) => setState(
            () {
              _pausePlay = "pause";
              _containerColor = Colors.orange;
              if (_current < 1) {
                timer.cancel();
                _pausePlay = "pause";
                _current = _matchTime;
                _containerColor = Colors.green;
                print("done");
              } else {
                _current = _current - 1;
              }
            },
          ),
        );
      }
    }
  }

  String intToTimeLeft(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);

    /*String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();*/
    String minuteLeft = m.toString();

    // m.toString().length < 2 ? "0" + m.toString() :
    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();
    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  Color _containerColor = Colors.green;

  // ****************** RED LOGIC ******************

  int _redFinalScore = 0;
  var arrayRedScore = [];
  String _redArrayText = "";

  void redButtonClicked(numb) {
    //debugPrint(numb);
    setState(() {
      arrayRedScore.add(numb);
      displayRed();
      _redFinalScore = addUpRedScore(arrayRedScore);
    });
  }

  int addUpRedScore(array) {
    if (array.length > 0) {
      return array.reduce((a, b) => a + b);
    } else {
      return 0;
    }
  }

  void displayRed() {
    String _text = "";
    arrayRedScore.forEach((element) {
      _text += '$element ';
    });
    _redArrayText = _text;
  }

  void _deleteRed() {
    setState(() {
      if (arrayRedScore.length > 0) {
        arrayRedScore.removeLast();
      }
      _redFinalScore = addUpRedScore(arrayRedScore);
      displayRed();
    });
  }

  // ****************** BLUE LOGIC ******************

  int _blueFinalScore = 0;
  var arrayBlueScore = [];
  String _blueArrayText = "";

  void blueButtonClicked(numb) {
    //debugPrint(numb);
    setState(() {
      arrayBlueScore.add(numb);
      displayBlue();
      _blueFinalScore = addUpBlueScore(arrayBlueScore);
    });
  }

  int addUpBlueScore(array) {
    if (array.length > 0) {
      return array.reduce((a, b) => a + b);
    } else {
      return 0;
    }
  }

  void displayBlue() {
    String _text = "";
    arrayBlueScore.forEach((element) {
      _text += '$element ';
    });
    _blueArrayText = _text;
  }

  void _deleteBlue() {
    setState(() {
      if (arrayBlueScore.length > 0) {
        arrayBlueScore.removeLast();
      }

      _blueFinalScore = addUpBlueScore(arrayBlueScore);
      displayBlue();
    });
  }

  void resetGame() {
    setState(() {
      startTimer(true);
      _redFinalScore = 0;
      arrayRedScore = [];
      _redArrayText = "";
      _blueFinalScore = 0;
      arrayBlueScore = [];
      _blueArrayText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _largeFont = 70;
    const double _smallFont = 22;
    const double _padding = 10.0;
    const double _spacing = 10.0;
    //const double _middleSpacing = 15.0;
    const double _bottomFont = 80;
    const double _borderRadius = 8;

    final ButtonStyle redStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: _largeFont, fontWeight: FontWeight.bold)));
    final ButtonStyle blueStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: _largeFont, fontWeight: FontWeight.bold)));
    final ButtonStyle redSmallerStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final ButtonStyle blueSmallerStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final TextStyle _scoreBoardStyle = TextStyle(
        fontSize: _smallFont, fontWeight: FontWeight.bold, color: Colors.black);

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: _spacing,
          ),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(_padding),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  child: Text(
                                    _redArrayText,
                                    style: _scoreBoardStyle,
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(_borderRadius),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _spacing,
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                              //ROW 2
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: redSmallerStyle,
                                    onPressed: () => redButtonClicked(-1),
                                    child: const Text('-1'),
                                  ),
                                ),
                                SizedBox(width: _spacing),
                                Expanded(
                                  child: ElevatedButton(
                                    style: redSmallerStyle,
                                    onPressed: () => redButtonClicked(-2),
                                    child: const Text('-2'),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: _spacing,
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                              //ROW 2
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: redSmallerStyle,
                                    onPressed: () => redButtonClicked(-5),
                                    child: const Text('-5'),
                                  ),
                                ),
                                SizedBox(width: _spacing),
                                Expanded(
                                  child: ElevatedButton(
                                    style: redSmallerStyle,
                                    onPressed: () => redButtonClicked(-10),
                                    child: const Text('-10'),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: _spacing,
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                              //ROW 2
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: redStyle,
                                    onPressed: () => redButtonClicked(1),
                                    child: FittedBox(
                                      child: const Text('1'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: _spacing),
                                Expanded(
                                  child: ElevatedButton(
                                    style: redStyle,
                                    onPressed: () => redButtonClicked(2),
                                    child: FittedBox(
                                      child: const Text('2'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: _spacing),
                                Expanded(
                                  child: ElevatedButton(
                                    style: redStyle,
                                    onPressed: () => redButtonClicked(3),
                                    child: FittedBox(
                                      child: const Text('3'),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: _spacing,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: _spacing,
                ),
                Expanded(
                  child: Container(
                      child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(_padding),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                child: Text(
                                  _blueArrayText,
                                  style: _scoreBoardStyle,
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(_borderRadius),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _spacing,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                            //ROW 2
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: blueSmallerStyle,
                                  onPressed: () => blueButtonClicked(-1),
                                  child: const Text('-1'),
                                ),
                              ),
                              SizedBox(width: _spacing),
                              Expanded(
                                child: ElevatedButton(
                                  style: blueSmallerStyle,
                                  onPressed: () => blueButtonClicked(-2),
                                  child: const Text('-2'),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: _spacing,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                            //ROW 2
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: blueSmallerStyle,
                                  onPressed: () => blueButtonClicked(-5),
                                  child: const Text('-5'),
                                ),
                              ),
                              SizedBox(width: _spacing),
                              Expanded(
                                child: ElevatedButton(
                                  style: blueSmallerStyle,
                                  onPressed: () => blueButtonClicked(-10),
                                  child: const Text('-10'),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: _spacing,
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                            //ROW 2
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: blueStyle,
                                  onPressed: () => blueButtonClicked(1),
                                  child: FittedBox(
                                    child: const Text('1'),
                                  ),
                                ),
                              ),
                              SizedBox(height: _spacing),
                              Expanded(
                                child: ElevatedButton(
                                  style: blueStyle,
                                  onPressed: () => blueButtonClicked(2),
                                  child: FittedBox(
                                    child: const Text('2'),
                                  ),
                                ),
                              ),
                              SizedBox(height: _spacing),
                              Expanded(
                                child: ElevatedButton(
                                  style: blueStyle,
                                  onPressed: () => blueButtonClicked(3),
                                  child: FittedBox(
                                    child: const Text('3'),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: _spacing,
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(_borderRadius),
                      ),
                    ),
                    child: Text(
                      '$_redFinalScore',
                      style: TextStyle(
                          fontSize: _bottomFont,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: _spacing,
                ),
                ElevatedButton(
                  child: const Icon(Icons.autorenew, size: 40),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Reset Match?'),
                      content: const Text('Are you sure you want to reset match and erase all the scores?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.pop(context, 'OK'),
                            resetGame()
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    shape: CircleBorder(),
                  ),
                ),
                SizedBox(
                  width: _spacing,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(_borderRadius),
                      ),
                    ),
                    child: Text(
                      '$_blueFinalScore',
                      style: TextStyle(
                          fontSize: _bottomFont,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _spacing,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _deleteRed();
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Colors.red,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
                SizedBox(
                  width: _spacing,
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _containerColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(_borderRadius),
                      ),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => startTimer(false),
                          child: Icon(
                            getTimerIcon(_pausePlay),
                            color: Colors.white,
                            size: 40.0,
                            semanticLabel: 'Start Timer',
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              intToTimeLeft(_current),
                              style: TextStyle(
                                  fontSize: _bottomFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => startTimer(true),
                          child: Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                            size: 40.0,
                            semanticLabel: 'Refresh Time',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: _spacing,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _deleteBlue();
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Colors.blue,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _spacing,
          ),
        ],
      ),
    );
  }
}
