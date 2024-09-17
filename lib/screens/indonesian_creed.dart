import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CreedIndonesian extends StatefulWidget {
  @override
  _CreedIndonesianState createState() => _CreedIndonesianState();
}

class _CreedIndonesianState extends State<CreedIndonesian> {
  final int flex1 = 1;
  final int flex2 = 4;
  final int flex1a = 1;
  final int flex2a = 5;
  final double spaceBetween = 5;
  final Color color1 = Colors.teal;
  final Color color2 = Colors.blue;
  final Color color3 = Colors.teal;
  final double _rightFontSize = 18;

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double currentPosition = 0.0;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
          currentPosition = 0.0; // Reset position
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        currentPosition = newPosition.inMilliseconds.toDouble();
      });
    });
  }

  void togglePlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource('audio/Ikrar.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void seek(double position) {
    audioPlayer.seek(Duration(milliseconds: position.round()));
  }

  @override
  void dispose() {
    if (isPlaying) {
      audioPlayer.stop(); // Ensure audio is stopped
    }
    audioPlayer.release(); // Release the resources
    audioPlayer.dispose(); // Dispose the AudioPlayer object
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creed in Indonesian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: togglePlay,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text("Play creed in Indonesian"),
                    style: ElevatedButton.styleFrom(),
                  ),
                  Slider(
                    value: currentPosition,
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        currentPosition = value;
                      });
                      seek(value);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Ikrar dan Janji",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text(
                      "Satu: ",
                      style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color1),
                    ),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Mengabdi kepada Allah, bangsa dan negara, serta membela keadilan dan kebenaran.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text(
                      "Dua: ",
                      style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color1),
                    ),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Mentaati azas-azas bela diri.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text(
                      "Tiga: ",
                      style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color1),
                    ),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Patuh dan taat kepada pimpinan serta disiplin pribadi.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text(
                      "Empat: ",
                      style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color1),
                    ),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Sanggup meningkatkan prestasi.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text(
                      "Lima",
                      style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color1),
                    ),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Dengan iman dan akhlak saya menjadi kuat. \nTanpa iman dan akhlak saya menjadi lemah.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
