import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter_beep/flutter_beep.dart';

class ScoringPortrait extends StatefulWidget {
  @override
  _ScoringPageState createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPortrait> {
  @override
  initState() {
    super.initState();
  }

  /* TIMER FUNCTIONS */

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
          showTimerDoneDialog();
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

  void showTimerDoneDialog() {
    showDialog(
      context: context, // Ensure context is available
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text("TIMER DONE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text("The timer has completed its countdown.",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
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
      return Colors.deepOrangeAccent; // Orange when paused
    } else {
      return Colors.pink!; // Dark yellow when stopped
    }
  }

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
    resetTimer();
    setState(() {
      _redFinalScore = 0;
      arrayRedScore = [];
      _redArrayText = "";
      _blueFinalScore = 0;
      arrayBlueScore = [];
      _blueArrayText = "";
    });
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
            width: double
                .infinity, // Adjust the height as needed to fit two rows of buttons// Add padding to the container
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
                SizedBox(height: 5), // Space between the two rows
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: Icon(
                                  _isRunning ? Icons.pause : Icons.play_arrow,
                                  size: 35),
                              label: Text(
                                getFormattedTime(),
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              onPressed: () => toggleTimer(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    getButtonColor(), // Correctly use backgroundColor instead of primary
                                minimumSize: Size(200, 60), // Button size
                                padding: EdgeInsets
                                    .zero, // No padding inside the button
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
                        )),
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
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius))),
        textStyle: WidgetStateProperty.all(TextStyle(
            fontSize: _largeFont,
            fontWeight: FontWeight.bold,
            color: Colors.white)));
    final ButtonStyle blueStyle = ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius))),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _largeFont, fontWeight: FontWeight.bold)));
    final ButtonStyle redSmallerStyle = ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius))),
        backgroundColor: WidgetStateProperty.all(Colors.red),
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: _smallFont, fontWeight: FontWeight.bold)));
    final ButtonStyle blueSmallerStyle = ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius))),
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
                          child: const Text('3', style: whiteTextColor),
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
              SizedBox(width: 10),
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
                            child: Text('3', style: whiteTextColor)),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Reset Match?'),
                              content: const Text(
                                  'Are you sure you want to reset match and erase all the scores?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
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
                            backgroundColor: Colors.purple,
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.autorenew,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple, // Correctly use backgroundColor instead of primary// Button size
                            padding: EdgeInsets.zero, // No padding inside the button
                          ),
                          onPressed: () => showTimeSelection(context),
                          child: Text('TIME',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ],
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
              SizedBox(height: _spacing), // Space between the two rows
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
                          semanticLabel: 'Delete Red',
                        ),
                      ),
                    ), // Delete Red
                    Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                    _isRunning ? Icons.pause : Icons.play_arrow,
                                    size: 35),
                                label: Text(
                                  getFormattedTime(),
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => toggleTimer(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      getButtonColor(), // Correctly use backgroundColor instead of primary// Button size
                                  padding: EdgeInsets
                                      .zero, // No padding inside the button
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () => resetTimer(),
                                child: Icon(Icons.refresh, size: 30),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: CircleBorder())),
                          ],
                        )),
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
                          semanticLabel: 'Delete Blue',
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
              ListTile(
                leading: Icon(Icons.timer),
                title: Text('4:00 minutes'),
                onTap: () => {Navigator.pop(context), setTime(240)},
              ),
            ],
          ),
        );
      },
    );
  }
}
