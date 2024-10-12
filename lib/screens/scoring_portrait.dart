import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';

class ScoringPortrait extends StatefulWidget {
  @override
  _ScoringPageState createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPortrait> {
  var _timer;
  int _matchTime = 120;
  int _current = 120;

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

  void startTimer(bool reset) {
    if (_timer != null) {
      if (_pausePlay == "pause") {
        // Pause timer
        setState(() {
          _pausePlay = "play";
          _containerColor = Colors.deepOrangeAccent;
        });
        _timer.cancel();
        _timer = null;
      } else {
        // Resume timer
        setState(() {
          _pausePlay = "pause";
          _containerColor = Colors.orange;
        });
        // No need to create a new Timer, just change state to resume
      }
    } else {
      // Timer is null, check if it's a reset or a fresh start
      if (reset) {
        // Reset timer
        setState(() {
          _pausePlay = "pause";
          _containerColor = Colors.green;
          _current = _matchTime;
        });
      }
      // Start timer from scratch
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_current < 1) {
              timer.cancel();
              _pausePlay = "play";
              _current = _matchTime;
              _containerColor = Colors.green;
              FlutterBeep.beep(false);

              // Show alert dialog
              showDialog(
                context: context, // Ensure context is available
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.red,
                    title: Text("TIMER DONE",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    content: Text("The timer has completed its countdown.",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                      ),
                    ],
                  );
                },
              );
            } else {
              _current--;
              _pausePlay = "pause";
              _containerColor = Colors.orange;
            }
          },
        ),
      );
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
  void deactivate() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.deactivate();
  }

  Column popupStats() {
    const double _largeFont = 70;
    const double _smallFont = 18;
    const double _padding = 10.0;
    const double _spacing = 10.0;
    const double _borderRadius = 8;
    const double spacing = 10.0;
    const double bottomFont = 40;
    const double borderRadius = 8;

    const TextStyle whiteTextColor = TextStyle(color: Colors.white);
    final ButtonStyle redStyle = ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.red),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
        textStyle: WidgetStateProperty.all(TextStyle(
            fontSize: _largeFont,
            fontWeight: FontWeight.bold,
            color: Colors.white)));
    final ButtonStyle blueStyle = ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _largeFont, fontWeight: FontWeight.bold)));
    final ButtonStyle redSmallerStyle = ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
        backgroundColor: WidgetStateProperty.all(Colors.red),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final ButtonStyle blueSmallerStyle = ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final TextStyle _scoreBoardStyle = TextStyle(
      fontSize: _smallFont,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1,
    );
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Row(
            children: <Widget>[
              Expanded(
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
                    // **************** BIG BUTTONS ************
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
                                  child: const Text('1', style: whiteTextColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redStyle,
                                onPressed: () => redButtonClicked(2),
                                child: FittedBox(
                                  child: const Text('2', style: whiteTextColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _spacing),
                            Expanded(
                              child: Row(
                                //ROW 2
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: redStyle,
                                        onPressed: () => redButtonClicked(3),
                                        child: FittedBox(
                                          child: const Text('3',
                                              style: whiteTextColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: _spacing),
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: redStyle,
                                        onPressed: () => redButtonClicked(4),
                                        child: FittedBox(
                                          child: const Text('4',
                                              style: whiteTextColor),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: _spacing,
                    ),
                    // **************** LITTLE BUTTONS ************
                    Expanded(
                      child: Row(
                        //ROW 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-1),
                                child: const Text('-1', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-2),
                                child: const Text('-2', style: whiteTextColor),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: _spacing,
                    ),
                    Expanded(
                      child: Row(
                        //ROW 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-5),
                                child: const Text('-5', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-10),
                                child: const Text('-10', style: whiteTextColor),
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
              SizedBox(
                width: 10.0, // Assuming _spacing is 10.0
              ),
              Expanded(
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
                    // **************** BIG BUTTONS ************
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
                                  child: const Text('1', style: whiteTextColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueStyle,
                                onPressed: () => blueButtonClicked(2),
                                child: FittedBox(
                                  child: const Text('2', style: whiteTextColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _spacing),
                            Expanded(
                              child: Row(
                                //ROW 2
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: blueStyle,
                                        onPressed: () => blueButtonClicked(3),
                                        child: const FittedBox(
                                            child: Text('3',
                                                style: whiteTextColor)),
                                      ),
                                    ),
                                    SizedBox(width: _spacing),
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: blueStyle,
                                        onPressed: () => blueButtonClicked(4),
                                        child: FittedBox(
                                            child: const Text('4',
                                                style: whiteTextColor)),
                                      ),
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: _spacing,
                    ),
                    // **************** LITTLE BUTTONS ************
                    Expanded(
                      child: Row(
                        //ROW 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-1),
                                child: const Text('-1', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-2),
                                child: const Text('-2', style: whiteTextColor),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: _spacing,
                    ),
                    Expanded(
                      child: Row(
                        //ROW 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-5),
                                child: const Text('-5', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-10),
                                child: const Text('-10', style: whiteTextColor),
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
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity, // Adjust the height as needed to fit two rows of buttons// Add padding to the container
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(borderRadius))),
                        child: FittedBox(
                          child: Text('$_redFinalScore',
                              style: const TextStyle(
                                  fontSize: bottomFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ), // Red Score
                    ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Reset Match?'),
                          content: const Text(
                              'Are you sure you want to reset match and erase all the scores?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                              {Navigator.pop(context, 'OK'), resetGame()},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.autorenew,
                        size: 40,
                        color: Colors.white,
                      ),
                    ), // Restart
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(borderRadius))),
                        child: FittedBox(
                          child: Text('$_blueFinalScore',
                              style: const TextStyle(
                                  fontSize: bottomFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ), // Blue Score
                  ],
                ),
                SizedBox(height: 5),// Space between the two rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _deleteRed();
                        },
                        child: const Icon(
                          Icons.backspace,
                          color: Colors.red,
                          size: 40.0,
                          semanticLabel:
                          'Text to announce in accessibility modes',
                        ),
                      ),
                    ), // Delete Red
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () => startTimer(false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _containerColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(borderRadius),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Adjust as needed
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                child: Icon(
                                  getTimerIcon(_pausePlay),
                                  color: Colors.white,
                                  size: 30.0,
                                  semanticLabel: 'Start Timer',
                                ),
                              ),
                              Text(
                                intToTimeLeft(_current),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                child: InkWell(
                                  onTap: () => startTimer(true),
                                  child: const Icon(
                                    Icons.refresh_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                    semanticLabel: 'Refresh Time',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _deleteBlue();
                        },
                        child: const Icon(
                          Icons.backspace,
                          color: Colors.blue,
                          size: 40.0,
                          semanticLabel:
                          'Text to announce in accessibility modes',
                        ),
                      ),
                    ), // Delete Blue
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double _largeFont = 70;
    const double _smallFont = 18;
    const double _padding = 10.0;
    const double _spacing = 10.0;
    const double _borderRadius = 8;
    const double spacing = 10.0;
    const double bottomFont = 70;
    const double buttonBorderRadius = 8;
    const double borderRadius = 8;

    const TextStyle whiteTextColor = TextStyle(color: Colors.white);
    final ButtonStyle redStyle = ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.red),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius))),
        textStyle: WidgetStateProperty.all(TextStyle(
            fontSize: _largeFont,
            fontWeight: FontWeight.bold,
            color: Colors.white)));
    final ButtonStyle blueStyle = ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius))),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _largeFont, fontWeight: FontWeight.bold)));
    final ButtonStyle redSmallerStyle = ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius))),
        backgroundColor: WidgetStateProperty.all(Colors.red),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final ButtonStyle blueSmallerStyle = ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius))),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final TextStyle _scoreBoardStyle = TextStyle(
      fontSize: _smallFont,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1,
    );

    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: redStyle,
                        onPressed: () => redButtonClicked(1),
                        child: FittedBox(
                          child: const Text('1', style: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: redStyle,
                        onPressed: () => redButtonClicked(2),
                        child: FittedBox(
                          child: const Text('2', style: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: redStyle,
                        onPressed: () => redButtonClicked(3),
                        child: FittedBox(
                          child: const Text('3',
                              style: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: _spacing),
                    Expanded(
                      child: Row(
                        //ROW 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-1),
                                child: const Text('-1', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-2),
                                child: const Text('-2', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-5),
                                child: const Text('-5', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: redSmallerStyle,
                                onPressed: () => redButtonClicked(-10),
                                child: const Text('-10', style: whiteTextColor),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: _spacing),
                  ],
                ),
              ),
              SizedBox(width:10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: blueStyle,
                        onPressed: () => blueButtonClicked(1),
                        child: FittedBox(
                          child: const Text('1', style: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: blueStyle,
                        onPressed: () => blueButtonClicked(2),
                        child: FittedBox(
                          child: const Text('2', style: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: _spacing),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: blueStyle,
                        onPressed: () => blueButtonClicked(3),
                        child: const FittedBox(
                            child: Text('3',
                                style: whiteTextColor)),
                      ),
                    ),
                    SizedBox(height: _spacing),
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
                                child: const Text('-1', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-2),
                                child: const Text('-2', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-5),
                                child: const Text('-5', style: whiteTextColor),
                              ),
                            ),
                            SizedBox(width: _spacing),
                            Expanded(
                              child: ElevatedButton(
                                style: blueSmallerStyle,
                                onPressed: () => blueButtonClicked(-10),
                                child: const Text('-10', style: whiteTextColor),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(height: _spacing),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(borderRadius))),
                        child: FittedBox(
                          child: Text('$_redFinalScore',
                              style: const TextStyle(
                                  fontSize: bottomFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ), // Red Score
                    ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Reset Match?'),
                          content: const Text(
                              'Are you sure you want to reset match and erase all the scores?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                              {Navigator.pop(context, 'OK'), resetGame()},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.autorenew,
                        size: 40,
                        color: Colors.white,
                      ),
                    ), // Restart
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(borderRadius))),
                        child: FittedBox(
                          child: Text('$_blueFinalScore',
                              style: const TextStyle(
                                  fontSize: bottomFont,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ), // Blue Score
                  ],
                ),
              ),
              SizedBox(height: _spacing),// Space between the two rows
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _deleteRed();
                        },
                        child: const Icon(
                          Icons.backspace,
                          color: Colors.red,
                          size: 40.0,
                          semanticLabel:
                          'Delete Red',
                        ),
                      ),
                    ), // Delete Red
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () => startTimer(false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _containerColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Adjust as needed
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                child: Icon(
                                  getTimerIcon(_pausePlay),
                                  color: Colors.white,
                                  size: 30.0,
                                  semanticLabel: 'Start Timer',
                                ),
                              ),
                              Text(
                                intToTimeLeft(_current),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                child: InkWell(
                                  onTap: () => startTimer(true),
                                  child: const Icon(
                                    Icons.refresh_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                    semanticLabel: 'Refresh Time',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _deleteBlue();
                        },
                        child: const Icon(
                          Icons.backspace,
                          color: Colors.blue,
                          size: 40.0,
                          semanticLabel:
                          'Delete Blue',
                        ),
                      ),
                    ), // Delete Blue
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
